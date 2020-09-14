<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

	<xsl:template name="personal_footer_in_simple_p1">
		<div class="footer">
			<div class="footer-in">
				<div class="row-fluid umi-footer">
					<div class="span12 toper">
						<button type="button" id="footer-btn" class="btn btn-umi-shop">&empty-collaple-menu;</button>
						<xsl:apply-templates select="document('udata://content/menu//1/')/udata" mode="main_menu"/>
					</div>

					<div class="span12 bottomer">
						<div class="row-fluid">
							<div class="span6 mt10">
								<xsl:call-template name="copyright_footer"/>
							</div>
							<div class="span3 mt10 f-code">
								<div class="text code_pre code_footer" umi:element-id="{$infoPageId}" umi:field-name="code_footer" umi:empty="&empty-code-footer;">
									<xsl:apply-templates select="$infoPage/property[@name = 'code_footer']/value" mode="code"/>
								</div>
							</div>
							<div class="span3 socio">
								<xsl:call-template name="social_block">
									<xsl:with-param name="class" select="'social_gray'"/>
								</xsl:call-template>
							</div>
						</div>
					</div>

				</div>
			</div>
		</div>
	</xsl:template>

</xsl:stylesheet>