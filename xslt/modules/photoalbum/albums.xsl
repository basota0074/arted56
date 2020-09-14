<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

	<xsl:template match="udata[@module = 'photoalbum'][@method = 'albums']"/>

	<xsl:template match="udata[@module = 'photoalbum'][@method = 'albums'][total]">
		<xsl:apply-templates select="items/item" />
	</xsl:template>

	<xsl:template match="udata[@module = 'photoalbum' and @method = 'albums']/items/item">
		<li class="photo_album" umi:element-id="{@id}" umi:region="row" umi:delete="delete" umi:delete-text="&delete-text-album;">
			<div class="photo_album_img_div">
				<a class="photo_album_img" href="{@link}">
					<xsl:call-template name="makeThumbnailSqueeze">
						<xsl:with-param name="element_id" select="@id" />
						<xsl:with-param name="field_name" select="'header_pic'" />
						<xsl:with-param name="width" select="$photoW" />
						<xsl:with-param name="height" select="$photoH" />
						<xsl:with-param name="alt" select="." />
						<xsl:with-param name="no-empty-image" select="0" />
					</xsl:call-template>
				</a>
			</div>
			<div class="photo_album_title">
				<a href="{@link}" umi:field-name="name" umi:field-type="string" umi:empty="&empty-page-name;">
					<xsl:value-of select="." disable-output-escaping="yes" />
				</a>
			</div>
		</li>
	</xsl:template>

</xsl:stylesheet>