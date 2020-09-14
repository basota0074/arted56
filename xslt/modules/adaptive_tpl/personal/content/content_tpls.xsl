<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">


	<xsl:template name="personal_content_in_complex_main_p1">
		<div class="row-fluid for-content">
			<div class="span12 prel">
				<div class="container mt20 mb20">

					<div class="pr_block">
						<xsl:call-template name="custom_block_2"/>
					</div>

					<xsl:apply-templates select="result" mode="main_top_date"/>
					<xsl:apply-templates select="result" mode="h1"/>
					<xsl:apply-templates select="document('udata://system/listErrorMessages/')/udata"/>
					<xsl:apply-templates select="."/>
					<xsl:apply-templates select="document('usel://getData//photoalbum/album/')/udata" mode="photoalbum_index"/>
				</div>
			</div>
		</div>
	</xsl:template>


	<xsl:template name="personal_content_in_complex_p1">
		<div class="row-fluid for-content">
			<div class="span12 prel">
				<div class="container">
					<div class="row-fluid umi-breadcrumb">
						<div class="span12">
							<xsl:apply-templates select="." mode="breadcrumb"/>
						</div>
					</div>

					<div class="row-fluid umi-second-content module-{@module} method-{@method}">
						<xsl:apply-templates select="result" mode="main_top_date"/>
						<xsl:apply-templates select="result" mode="h1"/>
						<xsl:apply-templates select="document('udata://system/listErrorMessages/')/udata" />
						<xsl:apply-templates select=".">
							<xsl:with-param name="show_page_submenu" select="0"/>
						</xsl:apply-templates>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>


</xsl:stylesheet>