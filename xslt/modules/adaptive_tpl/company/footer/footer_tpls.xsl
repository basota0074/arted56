<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

	<xsl:template name="footer_in_simple_c1">
		<div class="footer">
			<div class="footer-in">
				<div class="row-fluid umi-footer">
					<div class="span6 cp">
						<xsl:call-template name="copyright_footer"/>
					</div>
					<div class="span6">
						<div class="text code_pre code_footer" umi:element-id="{$infoPageId}" umi:field-name="code_footer" umi:empty="&empty-code-footer;">
							<xsl:apply-templates select="$infoPage/property[@name = 'code_footer']/value" mode="code"/>
						</div>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>

</xsl:stylesheet>