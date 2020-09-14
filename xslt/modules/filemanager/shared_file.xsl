<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi" xmlns:xlink="http://www.w3.org/TR/xlink">

    <xsl:template match="result[@module = 'filemanager'][@method = 'shared_file']">
		<xsl:variable name="file" select="document(concat('udata://filemanager/shared_file//',page/@id))/udata" />
        <xsl:variable name="fs_file" select="//group[@name = 'fs_file_props']/property[@name = 'fs_file']/value" />
		<div id="content_{$pageId}_{generate-id()}" class="text" umi:field-name="content" umi:field-type="wysiwyg" umi:element-id="{$pageId}" umi:empty="&empty-page-content;">
            <xsl:apply-templates select="//property[@name = 'content']" />
        </div>
		<ul class="list_files">
			<li umi:element-id="{@id}">
				<a href="/filemanager/download/{page/@id}" title="{@name} - {$file/file_name} ({$file/file_size} kB)">
					<span class="file_icon {$fs_file/@ext}">&nbsp;</span>
					<span class="file_info_link" umi:field-name="fs_file" umi:field-type="file" umi:empty="&empty-file;">
						<span class="link">
							<xsl:value-of select="page/name" disable-output-escaping="yes"/>.<xsl:value-of select="$fs_file/@ext"/>
						</span>
						<span class="file_info">&nbsp;(<xsl:value-of select="$file/file_size"/>&nbsp;kB)</span>
					</span>
				</a>
				<span umi:field-name="name" umi:field-type="string" umi:empty="&empty-file-name;"></span>
			</li>
		</ul>
    </xsl:template>
    
   
	
</xsl:stylesheet>