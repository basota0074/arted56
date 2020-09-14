<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

    <xsl:template match="result[@module = 'content'][@method = 'content']">
        <xsl:param name="show_page_submenu" select="1" />
        <xsl:apply-templates select="page" mode="content">
            <xsl:with-param name="show_page_submenu" select="$show_page_submenu" />
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="page" mode="content">
        <xsl:param name="show_page_submenu" select="1" />
        <div id="content_{$pageId}_{generate-id()}" class="text" umi:field-name="content" umi:field-type="wysiwyg" umi:element-id="{$pageId}" umi:empty="&empty-page-content;">
            <xsl:apply-templates select="//property[@name = 'content']" />
        </div>

        <!--Произвольный код на странице-->
        <xsl:choose>
			<xsl:when test="not(//property[@name = 'code']/value) and ($isAdmin = 0)"></xsl:when>
			<xsl:otherwise>
				<div class="content_code code_pre" umi:field-name="code" umi:field-type="text" umi:element-id="{$pageId}" umi:empty="&empty-code;">
                    <xsl:apply-templates select="//property[@name = 'code']/value" mode="code"/>
                </div>
			</xsl:otherwise>
		</xsl:choose>
		<!--Конец-->
        
        <!--Файлы для скачивания-->
        <xsl:apply-templates select="document(concat('udata://filemanager/list_files/',@id,'//1000/1/'))/udata" />
		<!--Конец-->
        
        <!--Для вывода меню внутри страницы контена-->
		<xsl:variable name="menu" select="document(concat('udata://content/menu//1/',@id,'/'))/udata" />
		<xsl:choose>
			<xsl:when test="(count($menu/items/item) = 0) and ($isAdmin = 0)"></xsl:when>
			<xsl:otherwise>
				<div class="text content_page_submenu page_submenu">
					<xsl:if test="count($menu/items/item) = 0">
						<xsl:attribute name="class">content_page_submenu page_submenu</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates select="$menu" mode="main_menu">
						<xsl:with-param name="id" select="@id" />
					</xsl:apply-templates>
				</div>
			</xsl:otherwise>
		</xsl:choose>
		<!--Конец-->
        
        <!--Отзывы-->
        <xsl:if test="$isAdmin = 1">
            <div class="hidden">
                <div class="hidden-text">
                    <span>&show-reviews;:</span>&nbsp;
                    <span umi:field-name="show_reviews" umi:field-type="boolean" umi:element-id="{$pageId}">
                        <xsl:choose>
                            <xsl:when test="//property[@name = 'show_reviews']/value = 1">&yes;</xsl:when>
                            <xsl:otherwise>&no;</xsl:otherwise>
                        </xsl:choose>
                    </span>
                </div>
            </div>
        </xsl:if>
        <xsl:if test="//property[@name = 'show_reviews']/value = 1">
            <xsl:call-template name="reviews">
				<xsl:with-param name="url" select="concat('http://',$_http_host,@link)" />
			</xsl:call-template>
        </xsl:if>
		<!--Конец-->
    </xsl:template>
    
    <xsl:template match="page[@is-default = '1']" mode="content">
        <div id="content_{$pageId}_{generate-id()}" class="index_text_content text" umi:field-name="content" umi:field-type="wysiwyg" umi:element-id="{$pageId}" umi:empty="&empty-page-content;">
            <xsl:apply-templates select="//property[@name = 'content']" />
        </div>
    </xsl:template>

</xsl:stylesheet>