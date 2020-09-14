<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

	<xsl:template name="footer_in_simple_s1">
		<div class="footer">
			<div class="footer-in">
				<div class="row-fluid f-fluid">
					<div class="span4 mt20">
						<xsl:call-template name="copyright_footer"/>
					</div>
					<div class="span8 footer-menu">
						<button type="button" id="footer-btn" class="btn btn-umi-shop">&empty-collaple-menu;</button>
						<div class="umi-menu">
							<xsl:apply-templates select="document('udata://content/menu//2/')/udata" mode="multilevel_menu"/>
						</div>

						<div class="text code_pre code_footer" umi:element-id="{$infoPageId}" umi:field-name="code_footer" umi:empty="&empty-code-footer;">
							<xsl:apply-templates select="$infoPage/property[@name = 'code_footer']/value" mode="code"/>
						</div>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>

</xsl:stylesheet>