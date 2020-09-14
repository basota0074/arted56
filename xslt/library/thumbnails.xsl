<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

	<xsl:template name="makeThumbnailSqueeze">
		<xsl:param name="alt" />
		<xsl:param name="class" />
		<xsl:param name="element_id" />
		<xsl:param name="object_id" />
		<xsl:param name="field_name" />
		<xsl:param name="width" select="'auto'" />
		<xsl:param name="height" select="'auto'" />
		<xsl:param name="empty-image">&empty-photo;</xsl:param>
		<xsl:param name="no-empty-image" select="1" />
		<xsl:variable name="path">
			<xsl:if test="$element_id">
				<xsl:value-of select="document(concat('upage://',$element_id))//property[@name = $field_name]/value/@path" />
			</xsl:if>
			<xsl:if test="$object_id">
				<xsl:value-of select="document(concat('uobject://',$object_id,'.',$field_name))/udata/property/value/@path" />
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="thumbnail" select="document(concat('udata://content/makeThumbnailSqueeze/(',$path,')/',$width,'/',$height,'/void/0/7/'))/udata"/>
		<xsl:choose>
			<xsl:when test="not($thumbnail/src) and ($no-empty-image = 1) and ($isAdmin = 0)" />
			<xsl:when test="not($thumbnail/src) and ($no-empty-image = 1) and ($isAdmin = 1)">
				<span class="hidden">
					<xsl:apply-templates select="$thumbnail" >
						<xsl:with-param name="alt" select="$alt" />
						<xsl:with-param name="class" select="$class" />
						<xsl:with-param name="element_id" select="$element_id" />
						<xsl:with-param name="object_id" select="$object_id" />
						<xsl:with-param name="field_name" select="$field_name" />
						<xsl:with-param name="empty_width" select="$width" />
						<xsl:with-param name="empty_height" select="$height" />
						<xsl:with-param name="empty-image" select="$empty-image" />
					</xsl:apply-templates>
				</span>
			</xsl:when>
			<xsl:when test="($no-empty-image = 0) and ($isAdmin = 1)">
				<xsl:apply-templates select="$thumbnail" >
					<xsl:with-param name="alt" select="$alt" />
					<xsl:with-param name="class" select="$class" />
					<xsl:with-param name="element_id" select="$element_id" />
					<xsl:with-param name="object_id" select="$object_id" />
					<xsl:with-param name="field_name" select="$field_name" />
					<xsl:with-param name="empty_width" select="$width" />
					<xsl:with-param name="empty_height" select="$height" />
					<xsl:with-param name="empty-image" select="$empty-image" />
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="$thumbnail" >
					<xsl:with-param name="alt" select="$alt" />
					<xsl:with-param name="class" select="$class" />
					<xsl:with-param name="element_id" select="$element_id" />
					<xsl:with-param name="object_id" select="$object_id" />
					<xsl:with-param name="field_name" select="$field_name" />
					<xsl:with-param name="empty_width" select="$width" />
					<xsl:with-param name="empty_height" select="$height" />
					<xsl:with-param name="empty-image" select="$empty-image" />
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="udata[@module = 'system' or @module = 'content'][@method = 'makeThumbnail' or @method = 'makeThumbnailFull' or @method = 'makeThumbnailSqueeze']">
		<xsl:param name="alt" select="''" />
		<xsl:param name="class" />
		<xsl:param name="element_id" />
		<xsl:param name="object_id" />
		<xsl:param name="field_name" />
		<xsl:param name="empty_width" select="'auto'" />
		<xsl:param name="empty_height" select="'auto'" />
		<xsl:param name="empty-image">&empty-photo;</xsl:param>
		<img>
			<xsl:attribute name="alt"><xsl:value-of select="$alt" disable-output-escaping="yes"/></xsl:attribute>
			<xsl:attribute name="title"><xsl:value-of select="$alt" disable-output-escaping="yes"/></xsl:attribute>
			<xsl:if test="$isAdmin = 1">
				<xsl:attribute name="style">
					<xsl:if test="$empty_width != 'auto'">
						<xsl:text>max-width:</xsl:text><xsl:value-of select="$empty_width"/><xsl:text>px;</xsl:text>
					</xsl:if>
					<xsl:if test="$empty_height != 'auto'">
						<xsl:text>max-height:</xsl:text><xsl:value-of select="$empty_height"/><xsl:text>px;</xsl:text>
					</xsl:if>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="$class">
				<xsl:attribute name="class"><xsl:value-of select="$class"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="$field_name">
				<xsl:if test="$element_id"><xsl:attribute name="umi:element-id"><xsl:value-of select="$element_id" /></xsl:attribute></xsl:if>
				<xsl:if test="$object_id"><xsl:attribute name="umi:object-id"><xsl:value-of select="$object_id" /></xsl:attribute></xsl:if>
				<xsl:attribute name="umi:field-name"><xsl:value-of select="$field_name" /></xsl:attribute>
				<xsl:attribute name="umi:field-type"><xsl:text>img_file</xsl:text></xsl:attribute>
			</xsl:if>
			<xsl:attribute name="src">
				<xsl:choose>
					<xsl:when test="src"><xsl:value-of select="src" /></xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="document(concat('udata://content/makeThumbnailSqueeze/(.',$empty-image,')/',$empty_width,'/',$empty_height,'/void/0/7/'))/udata/src" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="umi:empty"><xsl:value-of select="$empty-image" /></xsl:attribute>
		</img>
	</xsl:template>

	<xsl:template match="udata[(@module = 'system' or @module = 'content') and (@method = 'makeThumbnail' or @method = 'makeThumbnailFull' or @method = 'makeThumbnailSqueeze')]/width">
		<xsl:attribute name="width"><xsl:value-of select="." /></xsl:attribute>
	</xsl:template>

	<xsl:template match="udata[(@module = 'system' or @module = 'content') and (@method = 'makeThumbnail' or @method = 'makeThumbnailFull' or @method = 'makeThumbnailSqueeze')]/height">
		<xsl:attribute name="height"><xsl:value-of select="." /></xsl:attribute>
	</xsl:template>

</xsl:stylesheet>
