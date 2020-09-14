<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">


	<xsl:template name="header_in_simple_c1">
		<div class="row-fluid for-adress">
			<div class="span12 pos-rel">
				<div class="cover-one"></div>
				<div class="container">
					<div class="row-fluid adress-block" umi:element-id="{$infoPageId}">
						<div class="span4 addr">
							<span class="address_string" umi:field-name="address" umi:empty="&empty-address;">
								<xsl:apply-templates select="$infoPage/property[@name = 'address']"/>
							</span>
						</div>
						<div class="span3 phone">
							<span class="phone_number" umi:field-name="telefon" umi:empty="&empty;">
								<xsl:apply-templates select="$infoPage/property[@name = 'telefon']"/>
							</span>
						</div>
						<div class="span5 search" id="min_lens">
							<xsl:apply-templates select="document('udata://search/insert_form/')/udata">
								<xsl:with-param name="class" select="'search2'"/>
							</xsl:apply-templates>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="row-fluid for-logo-block">
			<div class="span12 pos-rel">
				<div class="cover-two"></div>
				<div class="container">
					<div class="row-fluid logo-block">
						<div class="span4 logotype">
							<a href="/" class="logo">
								<xsl:call-template name="makeThumbnailSqueeze">
									<xsl:with-param name="element_id" select="$infoPageId"/>
									<xsl:with-param name="field_name" select="'logo'"/>
									<xsl:with-param name="width" select="'300'"/>
									<xsl:with-param name="alt" select="result/@title"/>
								</xsl:call-template>
							</a>
						</div>

						<div class="span8 nav-wrap">
							<div class="row-fluid umi-menu">
								<div class="span12">
									<div class="navbar">
										<div class="navbar-inner">
											<div class="container">
												<button type="button" class="btn btn-umi-shop b-navbar" data-toggle="collapse"
														data-target=".nav-collapse">≡
												</button>

												<div class="nav-collapse collapse">
													<xsl:apply-templates select="document('udata://content/menu//2/')/udata" mode="multilevel_menu"/>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>


	<xsl:template name="header_in_simple_c1.1">
		test_tpl_c1.1
	</xsl:template>


</xsl:stylesheet>