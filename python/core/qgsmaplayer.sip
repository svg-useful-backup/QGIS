
/** \class QgsMapLayer
 *  \brief Base class for all map layer types.
 * This class is the base class for all map layer types (vector, raster).
 */
class QgsMapLayer : QObject
{
%TypeHeaderCode
#include <qgsmaplayer.h>
%End

%ConvertToSubClassCode
  if (sipCpp->inherits("QgsMapLayer"))
  {
    sipClass = sipClass_QgsMapLayer;
    QgsMapLayer* layer = qobject_cast<QgsMapLayer*>(sipCpp);
    if (layer->type() == QgsMapLayer::VectorLayer)
    {
      sipClass = sipClass_QgsVectorLayer;
    }
    else if (layer->type() == QgsMapLayer::RasterLayer)
    {
      sipClass = sipClass_QgsRasterLayer;
    }
    else if (layer->type() == QgsMapLayer::PluginLayer)
    {
      sipClass = sipClass_QgsPluginLayer;
    }
  }
  else
  {
    sipClass = 0;
  }

%End

  public:
    /** Layers enum defining the types of layers that can be added to a map */
    enum LayerType
    {
      VectorLayer,
      RasterLayer,
      PluginLayer
    };

    /** Constructor
     * @param type Type of layer as defined in QgsMapLayer::LayerType enum
     * @param lyrname Display Name of the layer
     * @param source datasource of layer
     */
    QgsMapLayer( QgsMapLayer::LayerType type = QgsMapLayer::VectorLayer, const QString& lyrname = QString::null, const QString& source = QString::null );

    /** Destructor */
    virtual ~QgsMapLayer();

    /** Get the type of the layer
     * @return Integer matching a value in the QgsMapLayer::LayerType enum
     */
    QgsMapLayer::LayerType type() const;

    /** Get this layer's unique ID, this ID is used to access this layer from map layer registry */
    QString id() const;

    /** Set the display name of the layer
     * @param name New name for the layer
     */
    void setLayerName( const QString & name );

    /** Get the display name of the layer
     * @return the layer name
     */
    QString name() const;

    /** Get the original name of the layer */
    QString originalName() const;

    void setTitle( const QString& title );
    QString title() const;

    void setAbstract( const QString& abstract );
    QString abstract() const;

    void setKeywordList( const QString& keywords );
    QString keywordList() const;

    /* Layer dataUrl information */
    void setDataUrl( const QString& dataUrl );
    QString dataUrl() const;
    void setDataUrlFormat( const QString& dataUrlFormat );
    QString dataUrlFormat() const;

    /* Layer attribution information */
    void setAttribution( const QString& attrib );
    QString attribution() const;
    void setAttributionUrl( const QString& attribUrl );
    QString attributionUrl() const;

    /* Layer metadataUrl information */
    void setMetadataUrl( const QString& metaUrl );
    QString metadataUrl() const;
    void setMetadataUrlType( const QString& metaUrlType );
    QString metadataUrlType() const;
    void setMetadataUrlFormat( const QString& metaUrlFormat );
    QString metadataUrlFormat() const;

    /** Set the blending mode used for rendering a layer */
    void setBlendMode( const QPainter::CompositionMode &blendMode );
    /** Returns the current blending mode for a layer */
    QPainter::CompositionMode blendMode() const;

    /** Synchronises with changes in the datasource
        */
    virtual void reload();

    /** Return new instance of QgsMapLayerRenderer that will be used for rendering of given context
     * @note added in 2.4
     */
    virtual QgsMapLayerRenderer* createMapRenderer( QgsRenderContext& rendererContext ) /Factory/;

    /** This is the method that does the actual work of
     * drawing the layer onto a paint device.
     * @param rendererContext describes the extents,
     * resolumon etc. that should be used when rendering the
     * layer.
     */
    virtual bool draw( QgsRenderContext& rendererContext );

    /** Draw labels
     * @todo to be removed: used only in vector layers
     */
    virtual void drawLabels( QgsRenderContext& rendererContext );

    /** Return the extent of the layer */
    virtual QgsRectangle extent();

    /** Return the status of the layer. An invalid layer is one which has a bad datasource
     * or other problem. Child classes set this flag when intialized
     * @return True if the layer is valid and can be accessed
     */
    bool isValid();

    /** Gets a version of the internal layer definition that has sensitive
      *  bits removed (for example, the password). This function should
      * be used when displaying the source name for general viewing.
     */
    QString publicSource() const;

    /** Returns the source for the layer */
    QString source() const;

    /**
     * Returns the sublayers of this layer
     * (Useful for providers that manage their own layers, such as WMS)
     */
    virtual QStringList subLayers() const;

    /**
     * Reorders the *previously selected* sublayers of this layer from bottom to top
     * (Useful for providers that manage their own layers, such as WMS)
     */
    virtual void setLayerOrder( const QStringList &layers );

    /** Set the visibility of the given sublayer name */
    virtual void setSubLayerVisibility( const QString& name, bool vis );

    /** True if the layer can be edited */
    virtual bool isEditable() const;

    /** Sets state from Dom document
       @param layerElement The Dom element corresponding to ``maplayer'' tag
       @note

       The Dom node corresponds to a Dom document project file XML element read
       by QgsProject.

       This, in turn, calls readXml(), which is over-rideable by sub-classes so
       that they can read their own specific state from the given Dom node.

       Invoked by QgsProject::read().

       @returns true if successful
     */
    bool readLayerXML( const QDomElement& layerElement );


    /** Stores state in Dom node
       @param layerElement is a Dom element corresponding to ``maplayer'' tag
       @param document is a the dom document being written
       @param relativeBasePath base path for relative paths
       @note

       The Dom node corresponds to a Dom document project file XML element to be
       written by QgsProject.

       This, in turn, calls writeXml(), which is over-rideable by sub-classes so
       that they can write their own specific state to the given Dom node.

       Invoked by QgsProject::write().

       @returns true if successful
    */
    bool writeLayerXML( QDomElement& layerElement, QDomDocument& document, const QString& relativeBasePath = QString::null );

    /** Returns the given layer as a layer definition document
        Layer definitions store the data source as well as styling and custom properties.

        Layer definitions can be used to load a layer and styling all from a single file.
    */
    static QDomDocument asLayerDefinition( const QList<QgsMapLayer*>& layers, const QString& relativeBasePath = QString::null );

    /** Creates a new layer from a layer defininition document
    */
    static QList<QgsMapLayer*> fromLayerDefinition( QDomDocument& document );
    static QList<QgsMapLayer*> fromLayerDefinitionFile( const QString &qlrfile );

    /** Set a custom property for layer. Properties are stored in a map and saved in project file. */
    void setCustomProperty( const QString& key, const QVariant& value );
    /** Read a custom property from layer. Properties are stored in a map and saved in project file. */
    QVariant customProperty( const QString& value, const QVariant& defaultValue = QVariant() ) const;
    /** Remove a custom property from layer. Properties are stored in a map and saved in project file. */
    void removeCustomProperty( const QString& key );


    //! @deprecated since 2.4 - returns empty string
    virtual QString lastErrorTitle() /Deprecated/;

    //! @deprecated since 2.4 - returns empty string
    virtual QString lastError() /Deprecated/;

    /** Get current status error. This error describes some principal problem
     *  for which layer cannot work and thus is not valid. It is not last error
     *  after accessing data by draw() etc.
     */
    virtual QgsError error() const;

    /** Returns layer's spatial reference system
    @note This was introduced in QGIS 1.4
    */
    const QgsCoordinateReferenceSystem& crs() const;

    /** Sets layer's spatial reference system */
    void setCrs( const QgsCoordinateReferenceSystem& srs, bool emitSignal = true );

    /** A convenience function to (un)capitalise the layer name */
    static QString capitaliseLayerName( const QString& name );

    /** Retrieve the style URI for this layer
     * (either as a .qml file on disk or as a
     * record in the users style table in their personal qgis.db)
     * @return a QString with the style file name
     * @see also loadNamedStyle () and saveNamedStyle ();
     */
    virtual QString styleURI();

    /** Retrieve the default style for this layer if one
     * exists (either as a .qml file on disk or as a
     * record in the users style table in their personal qgis.db)
     * @param theResultFlag a reference to a flag that will be set to false if
     * we did not manage to load the default style.
     * @return a QString with any status messages
     * @see also loadNamedStyle ();
     */
    virtual QString loadDefaultStyle( bool & theResultFlag /Out/ );

    /** Retrieve a named style for this layer if one
     * exists (either as a .qml file on disk or as a
     * record in the users style table in their personal qgis.db)
     * @param theURI - the file name or other URI for the
     * style file. First an attempt will be made to see if this
     * is a file and load that, if that fails the qgis.db styles
     * table will be consulted to see if there is a style who's
     * key matches the URI.
     * @param theResultFlag a reference to a flag that will be set to false if
     * we did not manage to load the default style.
     * @return a QString with any status messages
     * @see also loadDefaultStyle ();
     */
    virtual QString loadNamedStyle( const QString &theURI, bool &theResultFlag /Out/ );

    virtual bool loadNamedStyleFromDb( const QString &db, const QString &theURI, QString &qml /Out/ );

    /**
     * Import the properties of this layer from a QDomDocument
     * @param doc source QDomDocument
     * @param errorMsg this QString will be initialized on error
     * during the execution of readSymbology
     * @return true on success
     * @note added in 2.8
     */
    virtual bool importNamedStyle( QDomDocument& doc, QString &errorMsg /Out/ );

    /**
     * Export the properties of this layer as named style in a QDomDocument
     * @param doc the target QDomDocument
     * @param errorMsg this QString will be initialized on error
     * during the execution of writeSymbology
     */
    virtual void exportNamedStyle( QDomDocument &doc, QString &errorMsg );


    /**
     * Export the properties of this layer as SLD style in a QDomDocument
     * @param doc the target QDomDocument
     * @param errorMsg this QString will be initialized on error
     * during the execution of writeSymbology
     */
    virtual void exportSldStyle( QDomDocument &doc, QString &errorMsg );

    /** Save the properties of this layer as the default style
     * (either as a .qml file on disk or as a
     * record in the users style table in their personal qgis.db)
     * @param theResultFlag a reference to a flag that will be set to false if
     * we did not manage to save the default style.
     * @return a QString with any status messages
     * @sa loadNamedStyle() and @see saveNamedStyle()
     */
    virtual QString saveDefaultStyle( bool & theResultFlag /Out/ );

    /** Save the properties of this layer as a named style
     * (either as a .qml file on disk or as a
     * record in the users style table in their personal qgis.db)
     * @param theURI the file name or other URI for the
     * style file. First an attempt will be made to see if this
     * is a file and save to that, if that fails the qgis.db styles
     * table will be used to create a style entry who's
     * key matches the URI.
     * @param theResultFlag a reference to a flag that will be set to false if
     * we did not manage to save the default style.
     * @return a QString with any status messages
     * @sa saveDefaultStyle()
     */
    virtual QString saveNamedStyle( const QString &theURI, bool &theResultFlag /Out/ );

    virtual QString saveSldStyle( const QString &theURI, bool &theResultFlag );
    virtual QString loadSldStyle( const QString &theURI, bool &theResultFlag );

    virtual bool readSld( const QDomNode &node, QString &errorMessage );

    /** Read the symbology for the current layer from the Dom node supplied.
     * @param node node that will contain the symbology definition for this layer.
     * @param errorMessage reference to string that will be updated with any error messages
     * @return true in case of success.
    */
    virtual bool readSymbology( const QDomNode& node, QString& errorMessage ) = 0;

    /** Write the symbology for the layer into the docment provided.
     *  @param node the node that will have the style element added to it.
     *  @param doc the document that will have the QDomNode added.
     *  @param errorMessage reference to string that will be updated with any error messages
     *  @return true in case of success.
     */
    virtual bool writeSymbology( QDomNode &node, QDomDocument& doc, QString& errorMessage ) const = 0;

    /** Return pointer to layer's undo stack */
    QUndoStack *undoStack();

    /* Layer legendUrl information */
    void setLegendUrl( const QString& legendUrl );
    QString legendUrl() const;
    void setLegendUrlFormat( const QString& legendUrlFormat );
    QString legendUrlFormat() const;

    /** @deprecated since 2.4 - returns NULL */
    QImage *cacheImage() /Deprecated/;
    /** @deprecated since 2.4 - caches listen to repaintRequested() signal to invalidate the cached image */
    void setCacheImage( QImage * thepImage /Transfer/ ) /Deprecated/;
    /** @deprecated since 2.4 - does nothing */
    virtual void onCacheImageDelete() /Deprecated/;

    /**
     * Assign a legend controller to the map layer. The object will be responsible for providing legend items.
     * @param legend Takes ownership of the object. Can be null pointer
     * @note added in 2.6
     */
    void setLegend( QgsMapLayerLegend* legend /Transfer/ );
    /**
     * Can be null.
     * @note added in 2.6
     */
    QgsMapLayerLegend* legend() const;

    /**
     * Get access to the layer's style manager. Style manager allows switching between multiple styles.
     * @note added in 2.8
     */
    QgsMapLayerStyleManager* styleManager() const;

    /** Returns the minimum scale denominator at which the layer is visible.
     * Scale based visibility is only used if hasScaleBasedVisibility is true.
     * @returns minimum scale denominator at which the layer will render
     * @see setMinimumScale
     * @see maximumScale
     * @see hasScaleBasedVisibility
     */
    float minimumScale() const;

    /** Returns the maximum scale denominator at which the layer is visible.
     * Scale based visibility is only used if hasScaleBasedVisibility is true.
     * @returns minimum scale denominator at which the layer will render
     * @see setMaximumScale
     * @see minimumScale
     * @see hasScaleBasedVisibility
     */
    float maximumScale() const;

    /** Returns whether scale based visibility is enabled for the layer.
     * @returns true if scale based visibility is enabled
     * @see minimumScale
     * @see maximumScale
     * @see setScaleBasedVisibility
    */
    bool hasScaleBasedVisibility() const;

  public slots:

    /** Event handler for when a coordinate transform fails due to bad vertex error */
    virtual void invalidTransformInput();

    /** Sets the minimum scale denominator at which the layer will be visible.
     * Scale based visibility is only used if setScaleBasedVisibility is set to true.
     * @param theMinScale minimum scale denominator at which the layer should render
     * @see minimumScale
     * @see setMaximumScale
     * @see setScaleBasedVisibility
     */
    void setMinimumScale( const float theMinScale );

    /** Sets the maximum scale denominator at which the layer will be visible.
     * Scale based visibility is only used if setScaleBasedVisibility is set to true.
     * @param theMaxScale maximum scale denominator at which the layer should render
     * @see maximumScale
     * @see setMinimumScale
     * @see setScaleBasedVisibility
     */
    void setMaximumScale( const float theMaxScale );

    /** Sets whether scale based visibility is enabled for the layer.
     * @param enabled set to true to enable scale based visibility
     * @see setMinimumScale
     * @see setMaximumScale
     * @see scaleBasedVisibility
     */
    void setScaleBasedVisibility( const bool enabled );

    /** Accessor for the scale based visilibility flag
     * @deprecated use setScaleBasedVisibility instead
    */
    void toggleScaleBasedVisibility( bool theVisibilityFlag ) /Deprecated/;

    /** Clear cached image
     *  @deprecated in 2.4 - use triggerRepaint() - caches automatically listen to repaintRequested() signal to invalidate the cached image */
    void clearCacheImage() /Deprecated/;

    /**
     * Will advice the map canvas (and any other interested party) that this layer requires to be repainted.
     * Will emit a repaintRequested() signal.
     *
     * @note in 2.6 function moved from vector/raster subclasses to QgsMapLayer
     */
    void triggerRepaint();

    /** \brief Obtain Metadata for this layer */
    virtual QString metadata();

    /** Time stamp of data source in the moment when data/metadata were loaded by provider */
    virtual QDateTime timestamp() const;

  signals:

    //! @deprecated in 2.4 - not emitted anymore
    void drawingProgress( int theProgress, int theTotalSteps );

    /** Emit a signal with status (e.g. to be caught by QgisApp and display a msg on status bar) */
    void statusChanged( const QString& theStatus );

    /** Emit a signal that the layer name has been changed */
    void layerNameChanged();

    /** Emit a signal that layer's CRS has been reset */
    void layerCrsChanged();

    /** By emitting this signal the layer tells that either appearance or content have been changed
     * and any view showing the rendered layer should refresh itself.
     */
    void repaintRequested();

    //! \note Deprecated in 2.4 and not emitted anymore
    void screenUpdateRequested();

    /** This is used to send a request that any mapcanvas using this layer update its extents */
    void recalculateExtents();

    /** Data of layer changed */
    void dataChanged();

    /** Signal emitted when the blend mode is changed, through QgsMapLayer::setBlendMode() */
    void blendModeChanged( const QPainter::CompositionMode &blendMode );

    /** Signal emitted when renderer is changed */
    void rendererChanged();

    /**
     * Signal emitted when legend of the layer has changed
     * @note added in 2.6
     */
    void legendChanged();

  protected:
    /** Set the extent */
    virtual void setExtent( const QgsRectangle &rect );

    /** Set whether layer is valid or not - should be used in constructor. */
    void setValid( bool valid );

    /** Called by readLayerXML(), used by children to read state specific to them from
        project files.
    */
    virtual bool readXml( const QDomNode& layer_node );

    /** Called by writeLayerXML(), used by children to write state specific to them to
        project files.
    */
    virtual bool writeXml( QDomNode & layer_node, QDomDocument & document );


    /** Read custom properties from project file.
      @param layerNode note to read from
      @param keyStartsWith reads only properties starting with the specified string (or all if the string is empty)*/
    void readCustomProperties( const QDomNode& layerNode, const QString& keyStartsWith = "" );

    /** Write custom properties to project file. */
    void writeCustomProperties( QDomNode & layerNode, QDomDocument & doc ) const;

    /** Read style manager's configuration (if any). To be called by subclasses. */
    void readStyleManager( const QDomNode& layerNode );
    /** Write style manager's configuration (if exists). To be called by subclasses. */
    void writeStyleManager( QDomNode& layerNode, QDomDocument& doc ) const;


    /** Add error message */
    void appendError( const QgsErrorMessage & theMessage );
    /** Set error message */
    void setError( const QgsError & theError );
};
