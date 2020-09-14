<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi" xmlns:xlink="http://www.w3.org/TR/xlink">

	<!--Стандартное отображение файлов для скачивания-->
    <xsl:template match="udata[@module = 'filemanager'][@method = 'list_files']">
    	<xsl:variable name="sharedFileTypeId" select="document('utype://filemanager~shared_file')/udata/type/@id" />
		<xsl:choose>
			<xsl:when test="(count(items) = 0)">
				<xsl:if test="($isAdmin = 1)">
					 <ul class="list_files" umi:add-text="&add-text-file;" umi:region="list" umi:element-id="{$pageId}" umi:sortable="none" umi:button-position="top right" umi:module="{$module}" umi:type-id="{$sharedFileTypeId}">
						<li class="hidden no-style">
							<div class="hidden-text">
								<p>&empty-filemanager;</p>
							</div>
						</li>
						<li class="blank_item" umi:element-id="void" umi:region="row">
							<span class="file_wrapper">
								<a href="">
									<span class="file_icon"></span>
									<span class="file_info_link" umi:field-name="fs_file" umi:field-type="file" umi:empty="&empty-file;">
										<span class="link"></span>
									</span>
								</a>
							</span>
						</li>
					</ul>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<ul class="list_files" umi:region="list" umi:element-id="{$pageId}" umi:sortable="sortable" umi:button-position="top right" umi:module="{$module}" umi:type-id="{$sharedFileTypeId}">
					<xsl:apply-templates select="items" mode="file" />
				</ul>
			</xsl:otherwise>
		</xsl:choose>
    </xsl:template>
    
    <xsl:template match="items" mode="file">
        <xsl:variable name="file" select="document(concat('udata://filemanager/shared_file//',@id))/udata" />
        <xsl:variable name="fs_file" select="document(@xlink:href)/udata/page/properties/group[@name = 'fs_file_props']/property[@name = 'fs_file']/value" />
        <li umi:element-id="{@id}" umi:region="row">
			<span class="file_wrapper" umi:element-id="{@id}" umi:delete="delete">
				<a href="{@xlink:download-link}" title="{@name} - {$file/file_name} ({$file/file_size} kB)">
					<span class="file_icon {$fs_file/@ext}">&nbsp;</span>
					<span class="file_info_link" umi:field-name="fs_file" umi:field-type="file" umi:empty="&empty-file;">
						<span class="link">
							<xsl:value-of select="@name" disable-output-escaping="yes"/>.<xsl:value-of select="$fs_file/@ext"/>
						</span>
						<span class="file_info">&nbsp;(<xsl:value-of select="$file/file_size"/>&nbsp;kB)</span>
					</span>
				</a>
				<span class="link_name" umi:field-name="name" umi:field-type="string" umi:empty="&empty-file-name;"></span>
			</span>
        </li>
	</xsl:template>
	
</xsl:stylesheet>