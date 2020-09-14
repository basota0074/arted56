<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">


	<xsl:template name="personal_header_in_complex_main_p1">
		<div class="row-fluid for-main-header">
			<div class="span12 prel">
				<div class="cover-one"></div>
				<div class="container">
					<div class="row-fluid umi-header">
						<div class="span12">
							<div class="head_wr">

								<div class="head_search">
									<xsl:apply-templates select="document('udata://search/insert_form/')/udata"/>
								</div>

								<div class="head_logo_wr">
									<div class="head_logo" umi:element-id="{$infoPageId}" umi:empty="&empty-fio;" umi:field-name="imya_i_familiya">
										<xsl:apply-templates select="$infoPage/property[@name = 'imya_i_familiya']"/>
									</div>

									<div class="head_gan" umi:element-id="{$infoPageId}" umi:field-name="professiya_ili_slogan"
										 umi:empty="&empty-content;">
										<xsl:apply-templates select="$infoPage/property[@name = 'professiya_ili_slogan']"/>
									</div>

									<div class="head_slog">
										<xsl:call-template name="custom_block_1"/>
									</div>
								</div>
								<div class="head_img_wr">
									<xsl:call-template name="banner_1">
										<xsl:with-param name="html" select="0"/>
										<xsl:with-param name="width" select="940"/>
										<xsl:with-param name="height" select="'410'"/>
									</xsl:call-template>
								</div>
							</div>
						</div>
					</div>

					<div class="head_search_second mainer">
						<xsl:apply-templates select="document('udata://search/insert_form/')/udata"/>
					</div>
				</div>
			</div>
		</div>

		<div class="row-fluid for-menu">
			<div class="span12 prel">
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
											<xsl:apply-templates select="document('udata://content/menu//1/')/udata" mode="main_menu_p1"/>
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


	<xsl:template name="personal_header_in_complex_p1">
		<div class="row-fluid for-second-header">
			<div class="span12 prel">
				<div class="cover-two"></div>
				<div class="container">
					<div class="head_search_second">
						<xsl:apply-templates select="document('udata://search/insert_form/')/udata"/>
					</div>

					<div class="row-fluid umi-menu">
						<div class="span12">
							<div class="navbar">
								<div class="navbar-inner">
									<div class="container">
										<button type="button" class="btn btn-umi-shop b-navbar" data-toggle="collapse"
												data-target=".nav-collapse">&empty-collaple-menu;
										</button>

										<div class="nav-collapse collapse">
											<xsl:apply-templates select="document('udata://content/menu//1/')/udata" mode="main_menu_p1"/>
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