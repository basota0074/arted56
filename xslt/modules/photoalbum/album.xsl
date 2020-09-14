<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

	<!--Шаблон для страницы фотоальбома-->
	<xsl:template match="result[@module = 'photoalbum'][@method = 'album']">
		<div id="descr_{$pageId}_{generate-id()}" class="text" umi:element-id="{$pageId}" umi:field-name="descr" umi:field-type="wysiwyg" umi:empty="&empty-page-content;" >
			<xsl:apply-templates select=".//property[@name = 'descr']" />
		</div>
		<xsl:variable name="albums" select="document(concat('udata://photoalbum/albums//100500//',$pageId))/udata" />
		<xsl:variable name="photos" select="document(concat('udata://photoalbum/album/',$pageId,'//24'))/udata" />
		<ul class="photo_list" umi:element-id="{$pageId}" umi:region="list" umi:sortable="sortable" umi:button-position="top right" umi:add-prepend="prepend" umi:module="photoalbum" umi:add-method="none">
			<xsl:if test="$albums/total &gt; 0">
				<xsl:attribute name="umi:album-type-id"><xsl:value-of select="$albumPageTypeId" /></xsl:attribute>
			</xsl:if>
			<xsl:if test="$photos/total &gt; 0">
				<xsl:attribute name="umi:photo-type-id"><xsl:value-of select="$photoPageTypeId" /></xsl:attribute>
			</xsl:if>
			<xsl:if test="not($photos/total) and not($albums/total)">
				<xsl:attribute name="umi:photo-type-id"><xsl:value-of select="$photoPageTypeId" /></xsl:attribute>
				<xsl:attribute name="umi:album-type-id"><xsl:value-of select="$albumPageTypeId" /></xsl:attribute>
			</xsl:if>
			<xsl:if test="not($photos/total or $albums/total)">
				<xsl:attribute name="umi:photo-type-id"><xsl:value-of select="$photoPageTypeId" /></xsl:attribute>
				<xsl:attribute name="umi:album-type-id"><xsl:value-of select="$albumPageTypeId" /></xsl:attribute>
			</xsl:if>
			<xsl:if test="not($photos/total)"><xsl:call-template name="photo_blank" /></xsl:if>
			<xsl:if test="not($albums/total)"><xsl:call-template name="album_blank" /></xsl:if>
			<xsl:apply-templates select="$albums" />
			<xsl:apply-templates select="$photos">
				<xsl:with-param name="photo_album_name" select="page/@alt-name" />
			</xsl:apply-templates>
		</ul>
		<div class="photoalbum_numpages">
			<xsl:apply-templates select="document(concat('udata://system/numpages/',$photos/total,'/',$photos/per_page,'/'))/udata" />
		</div>
	</xsl:template>

	<xsl:template match="udata[@module = 'photoalbum'][@method = 'album']" />

	<xsl:template match="udata[@module = 'photoalbum'][@method = 'album'][total]">
		<xsl:param name="photo_album_name" select="$pageName" />
		<xsl:apply-templates select="items/item" mode="photoalbum_photo">
			<xsl:with-param name="photo_album_name" select="$photo_album_name" />
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="item|page" mode="photoalbum_photo">
		<xsl:param name="photo_album_name" select="$pageAltName" />
		<xsl:param name="width" select="$photoW" />
		<xsl:param name="height" select="$photoH" />
		<xsl:param name="no_page" select="0" />
		<xsl:variable name="photo_name">
			<xsl:choose>
				<xsl:when test="name"><xsl:value-of select="name" disable-output-escaping="yes"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="." disable-output-escaping="yes"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<li class="photo" umi:element-id="{@id}" umi:region="row" umi:delete="delete" umi:delete-text="&delete-text-photo;">
			<div class="photo_img_div">
				<a class="photo_img fancybox-group" title="{$photo_name}" rel="{$photo_album_name}">
					<xsl:choose>
						<xsl:when test="document(concat('upage://',@id,'.photo'))/udata/property/value">
							<xsl:attribute name="href">
								<xsl:value-of select="document(concat('upage://',@id,'.photo'))/udata/property/value" />
							</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="href">&empty-photo;</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:call-template name="makeThumbnailSqueeze">
						<xsl:with-param name="element_id" select="@id" />
						<xsl:with-param name="field_name" select="'photo'" />
						<xsl:with-param name="width" select="$width" />
						<xsl:with-param name="height" select="$height" />
						<xsl:with-param name="alt" select="$photo_name" />
						<xsl:with-param name="no-empty-image" select="0" />
					</xsl:call-template>
				</a>
			</div>
			<div class="photo_title">
				<xsl:choose>
					<xsl:when test="$no_page">
						<span umi:field-name="name" umi:field-type="string" umi:empty="&empty-page-name;">
							<xsl:value-of select="name" disable-output-escaping="yes" />
						</span>
					</xsl:when>
					<xsl:otherwise>
						<a href="{@link}" umi:field-name="name" umi:field-type="string" umi:empty="&empty-page-name;">
							<xsl:value-of select="." disable-output-escaping="yes" />
						</a>
					</xsl:otherwise>
				</xsl:choose>
			</div>
		</li>
	</xsl:template>

	<!--Шаблон для фотоальбома на главной странице-->
	<xsl:template match="udata" mode="photoalbum_index"/>

	<xsl:template match="udata[total != 0]" mode="photoalbum_index">
		<xsl:if test="$isAdmin = 1">
            <div class="hidden">
                <div class="hidden-text">
                    <span>&show-index-photoalbum;:</span>&nbsp;
                    <span umi:element-id="{$infoPageId}" umi:field-name="show_index_photoalbum" umi:field-type="boolean">
                        <xsl:choose>
                            <xsl:when test="$infoPagePreferences/property[@name = 'show_index_photoalbum']/value = 1">&yes;</xsl:when>
                            <xsl:otherwise>&no;</xsl:otherwise>
                        </xsl:choose>
                    </span>
                </div>
            </div>
        </xsl:if>
		<xsl:if test="$infoPagePreferences/property[@name = 'show_index_photoalbum']/value = 1">
			<xsl:variable name="albums" select="document(concat('udata://photoalbum/albums//',$indexPhotoalbum,'/1/',page/@id))/udata" />
			<xsl:variable name="photos" select="document(concat('udata://photoalbum/album/',page/@id,'//',$indexPhotoalbum))/udata" />
			<div class="photoalbum_index">
				<div class="mainpage_albums_title h2">
					<span class="h2_content" umi:element-id="{$infoPageId}" umi:field-name="mainpage_albums_title" umi:field-type="string" umi:empty="&empty-gallery-title;">
						<xsl:apply-templates select="$infoPage/property[@name = 'mainpage_albums_title']" />
					</span>
				</div>
				<xsl:variable name="albumsTotal" select="$albums/total" />
				<xsl:variable name="photosTotal" select="$photos/total" />
				<ul class="photo_list" umi:element-id="{page/@id}" umi:region="list" umi:module="photoalbum" umi:sortable="sortable" umi:button-position="top right" umi:add-prepend="none">
					<xsl:if test="$albumsTotal &gt; 0">
						<xsl:attribute name="umi:album-type-id"><xsl:value-of select="$albumPageTypeId" /></xsl:attribute>
					</xsl:if>
					<xsl:if test="$photosTotal &gt; 0">
						<xsl:attribute name="umi:photo-type-id"><xsl:value-of select="$photoPageTypeId" /></xsl:attribute>
					</xsl:if>
					<xsl:if test="not($photos/total or $albums/total)">
						<xsl:attribute name="umi:photo-type-id"><xsl:value-of select="$photoPageTypeId" /></xsl:attribute>
						<xsl:attribute name="umi:album-type-id"><xsl:value-of select="$albumPageTypeId" /></xsl:attribute>
					</xsl:if>
					<xsl:if test="not($photos/total)"><xsl:call-template name="photo_blank" /></xsl:if>
					<xsl:if test="not($albums/total)"><xsl:call-template name="album_blank" /></xsl:if>
					<xsl:apply-templates select="$photos">
						<xsl:with-param name="photo_album_name" select="page/@alt-name" />
						<xsl:with-param name="noPages" select="1" />
					</xsl:apply-templates>
					<xsl:apply-templates select="$albums">
						<xsl:with-param name="noPages" select="1" />
					</xsl:apply-templates>
				</ul>
				<xsl:choose>
					<xsl:when test="(($photosTotal &lt;= $indexPhotoalbum) or not($photosTotal)) and (($albumsTotal &lt;= $indexPhotoalbum) or not($albumsTotal))"/>
					<xsl:when test="$isAdmin = 0">
						<xsl:if test="$infoPage/property[@name = 'mainpage_albums_show_all']/value">
							<div class="show_all show_all_photoalbum" >
								<a href="{page/@link}" umi:field-name="mainpage_albums_show_all" umi:field-type="string" umi:empty="&empty-show-all;"  umi:element-id="{$infoPageId}">
									<xsl:apply-templates select="$infoPage/property[@name = 'mainpage_albums_show_all']" />
								</a>
							</div>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<div class="show_all show_all_photoalbum" >
							<xsl:if test="not($infoPage/property[@name = 'mainpage_albums_show_all']/value)">
								<xsl:attribute name="class">show_all show_all_photoalbum hidden</xsl:attribute>
							</xsl:if>
							<a href="{page/@link}" umi:field-name="mainpage_albums_show_all" umi:field-type="string" umi:empty="&empty-show-all;"  umi:element-id="{$infoPageId}">
								<xsl:apply-templates select="$infoPage/property[@name = 'mainpage_albums_show_all']" />
							</a>
						</div>
					</xsl:otherwise>
				</xsl:choose>
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template name="photo_blank">
		<xsl:if test="$isAdmin = 1">
			<li class="photo blank_item" umi:region="row" umi:delete="delete" umi:delete-text="&delete-text-photo;">
				<div class="photo_img_div">
					<a class="photo_img fancybox-group" href="" rel="" title="">
						<img umi:empty="&empty-photo;" src="&empty-photo;" umi:field-name="header_pic" umi:field-type="img_file" umi:element-id="" alt="">
							<xsl:attribute name="style">
								<xsl:text>max-width:</xsl:text><xsl:value-of select="$photoW"/><xsl:text>px;</xsl:text>
								<xsl:text>max-height:</xsl:text><xsl:value-of select="$photoH"/><xsl:text>px;</xsl:text>
							</xsl:attribute>
						</img>
					</a>
				</div>
				<div class="photo_title">
					<a umi:field-name="name" umi:field-type="string" umi:empty="&empty-page-name;"></a>
				</div>
			</li>
		</xsl:if>
	</xsl:template>

	<xsl:template name="album_blank">
		<xsl:if test="$isAdmin = 1">
			<li class="photo_album blank_item" umi:region="row" umi:delete="delete" umi:delete-text="&delete-text-album;">
				<div class="photo_album_img_div">
					<a class="photo_album_img" href="{@link}">
						<img umi:empty="&empty-photo;" src="&empty-photo;" umi:field-name="photo" umi:field-type="img_file" umi:element-id="" alt="">
							<xsl:attribute name="style">
								<xsl:text>max-width:</xsl:text><xsl:value-of select="$photoW"/><xsl:text>px;</xsl:text>
								<xsl:text>max-height:</xsl:text><xsl:value-of select="$photoH"/><xsl:text>px;</xsl:text>
							</xsl:attribute>
						</img>
					</a>
				</div>
				<div class="photo_album_title">
					<a href="{@link}" umi:field-name="name" umi:field-type="string" umi:empty="&empty-page-name;"></a>
				</div>
			</li>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>