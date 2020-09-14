<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:umi="http://www.umi-cms.ru/TR/umi"
	xmlns:php="http://php.net/xsl"
	extension-element-prefixes="php"
	exclude-result-prefixes="php">

	<xsl:template match="property[@type = 'string' or @type = 'int' or @type = 'float' or @type = 'price' or @type = 'text']|cut|content">
		<xsl:value-of select="value|../content|../cut" disable-output-escaping="yes" />
	</xsl:template>
	
	<xsl:template match="property[@type = 'wysiwyg']">
		<xsl:value-of select="value" disable-output-escaping="yes" />
	</xsl:template>

	<xsl:template match="property[@type = 'date']|publish_time|@publish_time">
		<xsl:param name="timestamp" select="value/@unix-timestamp|../publish_time|../@publish_time" />
		<xsl:param name="date_format" select="'&default-date-format;'" />
		<xsl:apply-templates select="document(concat('udata://system/convertDate/',$timestamp,'/',$date_format,'/'))/udata" />
	</xsl:template>

	<xsl:template match="property[@type = 'relation']">
		<ul><xsl:apply-templates select="value/item" /></ul>
	</xsl:template>

	<xsl:template match="property[@type = 'relation']/value/item">
		<li><xsl:value-of select="@name" disable-output-escaping="yes" /></li>
	</xsl:template>

	<xsl:template match="property[@type = 'tags']|tags">
		<xsl:param name="tag_link" select="''" />
		<xsl:apply-templates select="value|item/tag">
			<xsl:with-param name="tag_link" select="$tag_link" />
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="property[@type = 'tags']/value|tags/item/tag">
		<xsl:param name="tag_link" select="''" />
		<xsl:variable name="link" select="node()|../link" />
		<a href="{$tag_link}{$link}"><xsl:value-of select="." disable-output-escaping="yes" /></a><xsl:text>, </xsl:text>
	</xsl:template>

	<xsl:template match="property[@type = 'tags']/value[last()]|tags/item[last()]/tag">
		<xsl:param name="tag_link" select="''" />
		<xsl:variable name="link" select="node()|../link" />
		<a href="{$tag_link}{$link}"><xsl:value-of select="." disable-output-escaping="yes" /></a>
	</xsl:template>

	<xsl:template match="property[@type = 'img_file']" />
	
	<!--Таблицы редактируемые через EIP	-->
	<xsl:template match="property[@type = 'string' or @type = 'int' or @type = 'float' or @type = 'price' or @type = 'text' or @type = 'wysiwyg']|cut|content" mode="eip_props_table">
		<xsl:param name="class" select="'properties_tr'" />
		<tr>
			<xsl:attribute name="class">
				<xsl:call-template name="list_class" />
				<xsl:if test="(value = '')or(../content = '')or(../cut = '')">
					<xsl:text>hidden </xsl:text>
				</xsl:if>
				<xsl:value-of select="$class" />
			</xsl:attribute>
			<td class="prop_caption">
				<xsl:value-of select="title" disable-output-escaping="yes" /><xsl:text>:</xsl:text>
			</td>
			<td class="prop_value">
				<xsl:apply-templates select="." mode="eip_props_table_value"/>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="property[@type = 'date']|publish_time|@publish_time" mode="eip_props_table">
		<xsl:param name="timestamp" select="value/@unix-timestamp|../publish_time|../@publish_time" />
		<xsl:param name="date_format" select="'&default-date-format;'" />
		<xsl:param name="class" select="'properties_tr'" />
		<tr>
			<xsl:attribute name="class"><xsl:value-of select="$class" /></xsl:attribute>
			<td class="prop_caption">
				<xsl:value-of select="title" disable-output-escaping="yes" /><xsl:text>:</xsl:text>
			</td>
			<td class="prop_value">
				<xsl:apply-templates select="." mode="eip_props_table_value">
					<xsl:with-param name="timestamp" select="value/@unix-timestamp|../publish_time|../@publish_time" />
					<xsl:with-param name="date_format" select="'&default-date-format;'" />
				</xsl:apply-templates>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="property[@type = 'relation']" mode="eip_props_table">
		<xsl:param name="class" select="'properties_tr'" />
		<tr>
			<xsl:attribute name="class">
				<xsl:choose>
					<xsl:when test="(count(value/item) = 0) or not(value/item/@id)">
						<xsl:value-of select="concat('hidden ',$class)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$class" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<td class="prop_caption">
				<xsl:value-of select="title" disable-output-escaping="yes" /><xsl:text>:</xsl:text>
			</td>
			<td class="prop_value">
				<xsl:apply-templates select="." mode="eip_props_table_value" />
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="property[@type = 'boolean']" mode="eip_props_table">
		<xsl:param name="class" select="'properties_tr'" />
		<tr>
			<td class="prop_caption">
				<xsl:value-of select="title" disable-output-escaping="yes" /><xsl:text>:</xsl:text>
			</td>
			<td class="prop_value">
				<xsl:apply-templates select="." mode="eip_props_table_value"/>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="property[@type = 'tags']|tags" mode="eip_props_table">
		<xsl:param name="tag_link" select="''" />
		<xsl:apply-templates select="." mode="eip_props_table_value">
			<xsl:with-param name="tag_link" select="$tag_link" />
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="property[@type = 'img_file']" mode="eip_props_table" />
	
	<xsl:template match="property[@type = 'string' or @type = 'int' or @type = 'float' or @type = 'price' or @type = 'text' or @type = 'wysiwyg']|cut|content" mode="eip_props_table_value">
		<xsl:param name="id" select="$pageId" />
		<div umi:field-name="{@name}" umi:field-type="{@type}" umi:empty="&empty;" umi:element-id="{$id}">
			<xsl:value-of select="value|../content|../cut" disable-output-escaping="yes" />
		</div>
	</xsl:template>
	
	<xsl:template match="property[@type = 'date']|publish_time|@publish_time" mode="eip_props_table_value">
		<xsl:param name="timestamp" select="value/@unix-timestamp|../publish_time|../@publish_time" />
		<xsl:param name="date_format" select="'&default-date-format;'" />
		<xsl:param name="id" select="$pageId" />
		<div umi:field-name="{@name}" umi:field-type="{@type}" umi:empty="&empty-date;" umi:element-id="{$id}">
			<xsl:apply-templates select="document(concat('udata://system/convertDate/',$timestamp,'/',$date_format,'/'))/udata"/>
		</div>
	</xsl:template>
	
	<xsl:template match="property[@type = 'relation']" mode="eip_props_table_value">
		<xsl:param name="id" select="$pageId" />
		<ul umi:field-name="{@name}" umi:field-type="{@type}" umi:element-id="{$id}" umi:empty="&empty-choose;" >
			<xsl:apply-templates select="value/item" mode="eip_props_table_value" />
		</ul>
	</xsl:template>
	
	<xsl:template match="property[@type = 'relation']/value/item" mode="eip_props_table_value" />

	<xsl:template match="property[@type = 'relation']/value/item[@id]" mode="eip_props_table_value">
		<li><xsl:value-of select="@name" disable-output-escaping="yes" /></li>
	</xsl:template>
	
	<xsl:template match="property[@type = 'tags']|tags" mode="eip_props_table_value">
		<xsl:param name="tag_link" select="''" />
		<xsl:param name="id" select="$pageId" />
		<xsl:apply-templates select="value|item/tag" mode="eip_props_table_value">
			<xsl:with-param name="tag_link" select="$tag_link" />
			<xsl:with-param name="id" select="$id" />
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="property[@type = 'tags']/value|tags/item/tag" mode="eip_props_table_value">
		<xsl:param name="tag_link" select="''" />
		<xsl:param name="id" select="$pageId" />
		<xsl:variable name="link" select="node()|../link" />
		<a umi:field-name="{../@name}" umi:field-type="{../@type}" umi:empty="&empty-page-content;" umi:element-id="{$id}" href="{$tag_link}{$link}"><xsl:value-of select="." disable-output-escaping="yes" /></a><xsl:text>, </xsl:text>
	</xsl:template>

	<xsl:template match="property[@type = 'tags']/value[last()]|tags/item[last()]/tag" mode="eip_props_table_value">
		<xsl:param name="tag_link" select="''" />
		<xsl:param name="id" select="$pageId" />
		<xsl:variable name="link" select="node()|../link" />
		<a umi:field-name="{../@name}" umi:field-type="{../@type}" umi:empty="&empty-page-content;" umi:element-id="{$id}" href="{$tag_link}{$link}"><xsl:value-of select="." disable-output-escaping="yes" /></a>
	</xsl:template>
	
	<xsl:template match="property[@type = 'boolean']" mode="eip_props_table_value">
		<xsl:param name="id" select="$pageId" />
		<span umi:field-name="{@name}" umi:field-type="{@type}" umi:element-id="{$id}" >
			<xsl:apply-templates select="." mode="simple" />
		</span>
	</xsl:template>
	
	<xsl:template match="property[@type = 'img_file']/value" mode="eip_props_table_value" />
	
	<!--Вывод свойств-->
	
	<xsl:template match="property[@type = 'string' or @type = 'int' or @type = 'float' or @type = 'price' or @type = 'text' or @type = 'wysiwyg']|cut|content" mode="simple">
		<xsl:value-of select="value|../content|../cut" disable-output-escaping="yes" />
	</xsl:template>

	<xsl:template match="property[@type = 'date']|publish_time|@publish_time" mode="simple">
		<xsl:param name="timestamp" select="value/@unix-timestamp|../publish_time|../@publish_time" />
		<xsl:param name="date_format" select="'&default-date-format;'" />
		<xsl:apply-templates select="document(concat('udata://system/convertDate/',$timestamp,'/',$date_format,'/'))/udata" />
	</xsl:template>

	<xsl:template match="property[@type = 'relation']" mode="simple">
		<xsl:apply-templates select="value/item" mode="simple" />
	</xsl:template>

	<xsl:template match="property[@type = 'relation']/value/item" mode="simple">
		<xsl:value-of select="@name" disable-output-escaping="yes" />
		<xsl:if test="not(position() = last())">
			<xsl:text>, </xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="property[@type = 'img_file']" mode="simple" />
	
	<xsl:template match="value" mode="code">
		<xsl:choose>
			<xsl:when test="$isAdmin = 1">
				<xsl:value-of select="." disable-output-escaping="yes" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="php:function('htmlspecialchars_decode', string(.))" disable-output-escaping="yes" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="value" mode="code">
		<xsl:value-of select="php:function('htmlspecialchars_decode', string(.))" disable-output-escaping="yes" />
	</xsl:template>
	
	<xsl:template match="property[@type = 'boolean']" mode="simple">
		<xsl:text>&no;</xsl:text>
	</xsl:template>
	
	<xsl:template match="property[@type = 'boolean' and value = 1]" mode="simple">
		<xsl:text>&yes;</xsl:text>
	</xsl:template>

</xsl:stylesheet>