<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

	<xsl:template name="header_in_simple_s1">
		<div class="row-fluid for-adress">
			<div class="span12 pos-rel">
				<div class="cover-one"></div>
				<div class="container">
					<div class="row-fluid adress-block" umi:element-id="{$infoPageId}">
						<div class="span4 addr">
							<span class="address_string" umi:field-name="address" umi:empty="&empty-address;">
								<xsl:apply-templates select="$infoPage/property[@name = 'address']"/>
							</span>
							<span class="workhours" umi:field-name="rezhim_raboty" umi:empty="&empty-worktime;">
								<xsl:apply-templates select="$infoPage/property[@name = 'rezhim_raboty']"/>
							</span>
						</div>
						<div class="span4 phone">
							<span class="phone_number" umi:field-name="telefon" umi:empty="&empty;">
								<xsl:apply-templates select="$infoPage/property[@name = 'telefon']"/>
							</span>
						</div>
						<div class="span4 auth">
							<xsl:if test="$userType = 'guest'">
								<div class="auth_wrap">
									<div class="al">
										<a href="/users/login/">&log_in;</a>
									</div>
									<div class="ar">
										<a href="/users/registrate/">&registration;</a>
									</div>
								</div>
							</xsl:if>
							<xsl:if test="$userType != 'guest'">
								<div class="auth_wrap_logged">
									<div class="al">
										<a href="/emarket/personal/?personal_office=1">&my_orders;</a>
									</div>
									<div class="ar">
										<a href="/users/logout/">&log-out;</a>
									</div>
								</div>
							</xsl:if>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="row-fluid for-logo-block">
			<div class="span12 prel">
				<div class="container">
					<div class="row-fluid logo-block">
						<div class="span4 search" id="big_lens">
							<xsl:apply-templates select="document('udata://search/insert_form/')/udata">
								<xsl:with-param name="class" select="'search2'"/>
							</xsl:apply-templates>
						</div>
						<div class="span4 logotype">
							<a href="/" class="logo">
								<xsl:call-template name="makeThumbnailSqueeze">
									<xsl:with-param name="element_id" select="$infoPageId"/>
									<xsl:with-param name="field_name" select="'logo'"/>
									<xsl:with-param name="width" select="'171'"/>
									<xsl:with-param name="alt" select="result/@title"/>
								</xsl:call-template>
							</a>
						</div>
						<div class="span4 cart">
							<xsl:call-template name="header_basket"/>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="row-fluid for-umi-menu">
			<div class="span12 pos-rel">
				<div class="cover-two"></div>
				<div class="container">
					<div class="row-fluid umi-menu">
						<div class="span12">
							<div class="navbar">
								<div class="navbar-inner">
									<div class="container">
										<button type="button" class="btn btn-umi-shop b-navbar" data-toggle="collapse"
												data-target=".nav-collapse">&empty-collaple-menu;
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
	</xsl:template>

</xsl:stylesheet>