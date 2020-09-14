<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

	<xsl:template name="content_in_simple_c1">
		test_content_in_simple_c1
	</xsl:template>


	<xsl:template name="content_in_complex_main_c1">
		<div class="row-fluid for-content">
			<div class="span12 pos-rel">
				<div class="container">
					<div class="row-fluid umi-slider-false">
						<div class="span12">
							<div class="row-fluid main_image">

								<div class="span5">
									<div class="custom_wrapper_1 stc1" umi:element-id="{$infoPageId}" umi:field-name="professiya_ili_slogan" umi:empty="&empty-content;">
										<p>
											<xsl:apply-templates select="$infoPage/property[@name = 'professiya_ili_slogan']"/>
										</p>
									</div>
									<div class="custom_wrapper_2 stc2">
										<xsl:call-template name="custom_block_2"/>
									</div>
								</div>

								<div class="span7">
									<xsl:call-template name="banner_2">
										<xsl:with-param name="html" select="0"/>
										<xsl:with-param name="width" select="'610'"/>
										<xsl:with-param name="height" select="'375'"/>
									</xsl:call-template>
								</div>

							</div>
						</div>
					</div>

					<div class="row-fluid umi-content">
						<div class="span12">
							<div class="content-wrap">
								<div class="row-fluid">
									<div class="span4">
										<xsl:call-template name="banner_1">
											<xsl:with-param name="html" select="0"/>
											<xsl:with-param name="width" select="'287'"/>
											<xsl:with-param name="height" select="'340'"/>
										</xsl:call-template>
									</div>
									<div class="span8 social_old">

										<xsl:call-template name="social_block">
											<xsl:with-param name="class" select="'social_gray'"/>
										</xsl:call-template>

										<xsl:apply-templates select="."/>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="row-fluid umi-services mb20">
						<div class="span12">
							<xsl:apply-templates select="document('usel://getData//catalog/category/')/udata" mode="catalog_index"/>
						</div>
					</div>
					<div class="cleaner"/>
				</div>
			</div>
		</div>
	</xsl:template>


	<xsl:template name="content_in_complex_c1">
		<div class="row-fluid for-content">
			<div class="span12 pos-rel">
				<div class="container">
					<div class="row-fluid umi-breadcrumb">
						<div class="span12">
							<xsl:apply-templates select="." mode="breadcrumb"/>
						</div>
					</div>

					<div class="row-fluid umi-second-content">
						<xsl:if test="document('usel://getData//catalog/category/')/udata/total != 0">
							<div id="left_column" class="span3">
								<div class="menu-vertical">
									<xsl:call-template name="catalog_main_list"/>
								</div>
							</div>
						</xsl:if>

						<div id="center_column" class="span9 module-{@module} method-{@method}">
							<xsl:apply-templates select="." mode="main_top_date"/>
							<xsl:apply-templates select="." mode="h1"/>
							<xsl:apply-templates select="document('udata://system/listErrorMessages/')/udata"/>
							<xsl:apply-templates select="."/>
						</div>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>


</xsl:stylesheet>