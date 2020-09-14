<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM	"ulang://i18n/constants.dtd:file">

<xsl:stylesheet	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xlink="http://www.w3.org/TR/xlink">

	<xsl:template match="purchasing[@stage = 'required'][@step = 'personal']">
		<div class="basket_page">
			<div class="purchase_controls" id="system_basket">
				<div class="basket_table_wrapper">
					<div class="basket_table_title">
						<a class="all_system_buttons system_basket_go_back" href="/emarket/cart/">&basket-back-to-cart;</a>
						<div class="middle">
							<span class="basket_table_title_icon middle">&nbsp;</span>
							<span class="basket_table_title_text middle">&basket-title-contact-details;</span>
						</div>
						<div class="cleaner" />
					</div>
					<form class="site_form purchase_fields" enctype="multipart/form-data" method="post" action="{$lang-prefix}/emarket/purchase/required/personal/do/">
						<fieldset class="system_basket_fields">
							<xsl:apply-templates select="document(concat('udata://data/getEditForm/', customer-id))" mode="purchase"/>
							<xsl:call-template name="personal_data_notice" />

							<div class="field submit system_basket_submit">
								<input class="basket_submit_button" type="submit" value="&save-changes;" />
							</div>
							<div class="cleaner"/>
						</fieldset>
					</form>
				</div>
				<div class="cleaner"/>
			</div>
		</div>
		<div id="system_empty_basket_text">
			<xsl:call-template name="empty_basket"/>
	    </div>
	</xsl:template>
</xsl:stylesheet>
