<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM	"ulang://i18n/constants.dtd:file">

<xsl:stylesheet	version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="purchasing[@stage = 'payment'][@step = 'bonus']">
		<div class="basket_page">
			<div class="purchase_controls" id="system_basket">
				<div class="basket_table_wrapper">
					<div class="basket_table_title">
						<a class="all_system_buttons system_basket_go_back" href="/emarket/cart/">&basket-back-to-cart;</a>
						<div class="middle">
							<span class="basket_table_title_icon middle">&nbsp;</span>
							<span class="basket_table_title_text middle">Оплата бонусами</span>
						</div>
						<div class="cleaner" />
					</div>
					<form class="site_form purchase_fields" id="bonus_payment" method="post" action="do/">
						<fieldset class="system_basket_fields">
							<div style="margin:0 15px;">
								<xsl:text>Вы собираетесь оплатить заказ на сумму </xsl:text>
								<xsl:apply-templates select="bonus/@prefix" />
								<xsl:value-of select="bonus/actual_total_price" />
								<xsl:apply-templates select="bonus/@suffix" />
								<xsl:text>.</xsl:text>
							</div>
							<div style="margin:0 15px;">
								<xsl:text>Вы можете оплатить Ваш заказ накопленными бонусами. Доступно бонусов на </xsl:text>
								<xsl:apply-templates select="bonus/@prefix" />
								<xsl:value-of select="bonus/available_bonus" />
								<xsl:apply-templates select="bonus/@suffix" />
								<xsl:text>.</xsl:text>
							</div>
							<div><label><input type="text" name="bonus" />Количество бонусов</label></div>
							<div class="field submit system_basket_submit">
								<input class="basket_submit_button" type="submit" value="&continue;" />
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

	<xsl:template match="purchasing[@stage = 'payment']/bonus/@prefix">
		<xsl:value-of select="." />
		<xsl:text>&#160;</xsl:text>
	</xsl:template>

	<xsl:template match="purchasing[@stage = 'payment']/bonus/@suffix">
		<xsl:text>&#160;</xsl:text>
		<xsl:value-of select="." />
	</xsl:template>
	
	<xsl:template match="purchasing[@stage = 'payment'][@step = 'choose']">
		<div class="basket_page">
			<div class="purchase_controls" id="system_basket">
				<div class="basket_table_wrapper">
					<div class="basket_table_title">
						<a class="all_system_buttons system_basket_go_back" href="/emarket/cart/">&basket-back-to-cart;</a>
						<div class="middle">
							<span class="basket_table_title_icon middle">&nbsp;</span>
							<span class="basket_table_title_text middle">&payment-type;</span>
						</div>
						<div class="cleaner" />
					</div>
					<form class="site_form purchase_fields" id="payment_choose" method="post">
						<xsl:attribute name="action"><xsl:value-of select="submit_url" /></xsl:attribute>
						<xsl:text disable-output-escaping="yes">
							<![CDATA[
								<script>
									window.paymentId = null;
									jQuery('#payment_choose').submit(function(){
										if (window.paymentId) {
											var checkPaymentReceipt = function(id) {
												if (jQuery(':radio:checked','#payment_choose').attr('class') == 'receipt') {
													var url = "]]></xsl:text><xsl:value-of select="submit_url" /><xsl:text disable-output-escaping="yes"><![CDATA[";
													var win = window.open("", "_blank", "width=710,height=620,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=yes,resizable=no");
													win.document.write("<html><head><" + "script" + ">location.href = '" + url + "?payment-id=" + id + "'</" + "script" + "></head><body></body></html>");
													win.focus();
													return false;
												}
											}
											return checkPaymentReceipt(window.paymentId);
										}
										else return true;
									});
								</script>
							]]>
						</xsl:text>
						<fieldset class="system_basket_fields">
							<xsl:apply-templates select="items/item" mode="payment" />

							<xsl:call-template name="personal_data_notice" />

							<div class="field submit system_basket_submit">
								<input class="basket_submit_button" type="submit" value="&continue;" />
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

	<xsl:template match="item" mode="payment">
		<div>
			<label>
				<xsl:if test="(position() = 1) and (@type-name = 'receipt')">
					<script>
						window.paymentId = <xsl:value-of select="@id" />;
					</script>
				</xsl:if>
				<input type="radio" name="payment-id" class="{@type-name}" value="{@id}">
					<xsl:attribute name="onclick">
						<xsl:text>this.form.action = </xsl:text>
						<xsl:choose>
							<xsl:when test="@type-name != 'receipt'">
								<xsl:text>'</xsl:text>
								<xsl:value-of select="//submit_url" />
								<xsl:text>';</xsl:text>
							</xsl:when>
							<xsl:otherwise><xsl:text>'/emarket/ordersList/'; window.paymentId = '</xsl:text><xsl:value-of select="@id" /><xsl:text>';</xsl:text></xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:if test="position() = 1">
						<xsl:attribute name="checked">
							<xsl:text>checked</xsl:text>
						</xsl:attribute>
					</xsl:if>
				</input>
				<xsl:value-of select="@name" />
			</label>
		</div>
	</xsl:template>

	<xsl:template match="purchasing[@stage = 'payment'][@step = 'chronopay']">
		<form method="post" action="{formAction}">
			<input type="hidden" name="product_id" value="{product_id}" />
			<input type="hidden" name="product_name" value="{product_name}" />
			<input type="hidden" name="product_price" value="{product_price}" />
			<input type="hidden" name="language" value="{language}" />
			<input type="hidden" name="cs1" value="{cs1}" />
			<input type="hidden" name="cs2" value="{cs2}" />
			<input type="hidden" name="cs3" value="{cs3}" />
			<input type="hidden" name="cb_type" value="{cb_type}" />
			<input type="hidden" name="cb_url" value="{cb_url}" />
			<input type="hidden" name="decline_url" value="{decline_url}" />
			<input type="hidden" name="sign" value="{sign}" />

			<div>
				<xsl:text>&payment-redirect-text; Chronopay.</xsl:text>
			</div>

			<div>
				<input type="submit" value="Оплатить" class="button big" />
			</div>
		</form>
	</xsl:template>

	<xsl:template match="purchasing[@stage = 'payment'][@step = 'yandex']">
		<form action="{formAction}" method="post">
			<input type="hidden" name="shopId"	value="{shopId}" />
			<input type="hidden" name="Sum"		value="{Sum}" />
			<input type="hidden" name="BankId"	value="{BankId}" />
			<input type="hidden" name="scid"	value="{scid}" />
			<input type="hidden" name="CustomerNumber" value="{CustomerNumber}" />
			<input type="hidden" name="order-id" value="{orderId}" />

			<div>
				<xsl:text>&payment-redirect-text; Yandex.</xsl:text>
			</div>

			<div>
				<input type="submit" value="Оплатить" class="button big" />
			</div>
		</form>
	</xsl:template>

	<xsl:template match="purchasing[@stage = 'payment'][@step = 'payonline']">
		<form action="{formAction}" method="post">

			<input type="hidden" name="MerchantId" 	value="{MerchantId}" />
			<input type="hidden" name="OrderId" 	value="{OrderId}" />
			<input type="hidden" name="Currency" 	value="{Currency}" />
			<input type="hidden" name="SecurityKey" value="{SecurityKey}" />
			<input type="hidden" name="ReturnUrl" 	value="{ReturnUrl}" />
			<!-- NB! This field should exist for proper system working -->
			<input type="hidden" name="order-id"    value="{orderId}" />
			<input type="hidden" name="Amount" value="{Amount}" />

			<div>
				<xsl:text>&payment-redirect-text; PayOnline.</xsl:text>
			</div>

			<div>
				<input type="submit" value="Оплатить" class="button big" />
			</div>
		</form>
	</xsl:template>

	<xsl:template match="purchasing[@stage = 'payment'][@step = 'robox']">
		<form action="{formAction}" method="post">
			<input type="hidden" name="MrchLogin" value="{MrchLogin}" />
			<input type="hidden" name="OutSum"	  value="{OutSum}" />
			<input type="hidden" name="InvId"	  value="{InvId}" />
			<input type="hidden" name="Desc"	  value="{Desc}" />
			<input type="hidden" name="SignatureValue" value="{SignatureValue}" />
			<input type="hidden" name="IncCurrLabel"   value="{IncCurrLabel}" />
			<input type="hidden" name="Culture"   value="{Culture}" />
			<input type="hidden" name="shp_orderId" value="{shp_orderId}" />

			<div>
				<xsl:text>&payment-redirect-text; Robox.</xsl:text>
			</div>

			<div>
				<input type="submit" value="Оплатить" class="button big" />
			</div>
		</form>
	</xsl:template>

	<xsl:template match="purchasing[@stage = 'payment'][@step = 'rbk']">
		<form action="{formAction}" method="post">
			<input type="hidden" name="eshopId" value="{eshopId}" />
			<input type="hidden" name="orderId"	value="{orderId}" />
			<input type="hidden" name="recipientAmount"	value="{recipientAmount}" />
			<input type="hidden" name="recipientCurrency" value="{recipientCurrency}" />
			<input type="hidden" name="version" value="{version}" />

			<div>
				<xsl:text>&payment-redirect-text; RBK Money.</xsl:text>
			</div>

			<div>
				<input type="submit" value="Оплатить" class="button big" />
			</div>
		</form>
	</xsl:template>

	<xsl:template match="purchasing[@stage = 'payment'][@step = 'payanyway']">
		<form action="{formAction}" method="post">
            <input type="hidden" name="MNT_ID" value="{mntId}" />
            <input type="hidden" name="MNT_TRANSACTION_ID" value="{mnTransactionId}" />
            <input type="hidden" name="MNT_CURRENCY_CODE" value="{mntCurrencyCode}" />
            <input type="hidden" name="MNT_AMOUNT" value="{mntAmount}" />
            <input type="hidden" name="MNT_TEST_MODE" value="{mntTestMode}" />
            <input type="hidden" name="MNT_SIGNATURE" value="{mntSignature}" />
            <input type="hidden" name="MNT_SUCCESS_URL" value="{mntSuccessUrl}" />
            <input type="hidden" name="MNT_FAIL_URL" value="{mntFailUrl}" />

			<div>
				<xsl:text>&payment-redirect-text; PayAnyWay.</xsl:text>
			</div>

			<div>
				<input type="submit" value="Оплатить" class="button big" />
			</div>
		</form>
	</xsl:template>

	<xsl:template match="purchasing[@stage = 'payment'][@step = 'dengionline']">
		<form action="{formAction}" method="post">

			<input type="hidden" name="project" value="{project}" />
			<input type="hidden" name="amount" value="{amount}" />
			<input type="hidden" name="nickname" value="{order_id}" />
			<input type="hidden" name="source" value="{source}" />
			<input type="hidden" name="order_id" value="{order_id}" />
			<input type="hidden" name="comment" value="{comment}" />
			<input type="hidden" name="paymentCurrency" value="{paymentCurrency}" />

			<xsl:apply-templates select="items/item" mode="payment-modes" />

			<div>
				<input type="submit" value="Оплатить" class="button big" />
			</div>
		</form>
	</xsl:template>

	<xsl:template match="item" mode="payment-modes">
		<label><input type="radio" name="mode_type" value="{id}"/><xsl:value-of select="label"/></label>
	</xsl:template>

	<xsl:template match="purchasing[@stage = 'payment'][@step = 'invoice']" xmlns:xlink="http://www.w3.org/TR/xlink">
		<div class="purchase_controls">
			<form id="invoice" method="post" action="do" class="site_form purchase_fields">
				<xsl:apply-templates select="items" mode="legal-person">
					<xsl:with-param name="customer_email" select="customer/@e-mail" />
				</xsl:apply-templates>

				<xsl:call-template name="personal_data_notice" />

				<div class="field submit system_basket_submit">
					<input type="submit" value="Выписать счет" class="basket_submit_button" />
				</div>
			</form>
			<script>
				jQuery(document).ready(function() {
					application.emarket.toggleNewObjectForm('#invoice', '#new-legal-person');
				});
			</script>
		</div>
	</xsl:template>

	<xsl:template match="items" mode="legal-person" xmlns:xlink="http://www.w3.org/TR/xlink">
		<xsl:param name="customer_email" />
		
		<input type="hidden" name="legal-person" value="new" />
		<div id="new-legal-person">
			<xsl:apply-templates select="document(../@xlink:href)/udata" mode="legal_form" >
				<xsl:with-param name="customer_email" select="$customer_email"/>
			</xsl:apply-templates>
		</div>
	</xsl:template>

	<xsl:template match="items[count(item) &gt; 0]" mode="legal-person" xmlns:xlink="http://www.w3.org/TR/xlink">
		<xsl:param name="customer_email" />
		<h4>
			<xsl:text>&choose-legal_person;:</xsl:text>
		</h4>
		<xsl:apply-templates select="item" mode="legal-person" />

		<div>
			<label>
				<input type="radio" name="legal-person" value="new" />
				<xsl:text>&new-legal-person;</xsl:text>
			</label>
		</div>

		<div id="new-legal-person">
			<xsl:apply-templates select="document(../@xlink:href)/udata" mode="legal_form" >
				<xsl:with-param name="customer_email" select="$customer_email"/>
			</xsl:apply-templates>
		</div>

	</xsl:template>

	<xsl:template match="item" mode="legal-person"  xmlns:xlink="http://www.w3.org/TR/xlink">
		<xsl:variable name="person_name">
			<xsl:choose>
				<xsl:when test="@name and @name != ''">
					<xsl:value-of select="@name" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Безымянное юридическое лицо</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<div class="form_element">
			<label>
				<input type="radio" name="legal-person" value="{@id}">
					<xsl:if test="position() = 1">
						<xsl:attribute name="checked">
							<xsl:text>checked</xsl:text>
						</xsl:attribute>
					</xsl:if>
				</input>
				<xsl:value-of select="$person_name" />
			</label>
		</div>
	</xsl:template>
	
	<xsl:template match="udata" mode="legal_form">
		<xsl:param name="customer_email"/>
		
		<xsl:apply-templates select="//field[@name='name']"  mode="legal_form" >
			<xsl:with-param name="title" select="'Наименование организации'"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="//field[@name='inn']"   mode="legal_form" >
			<xsl:with-param name="title" select="'ИНН'"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="//field[@name='kpp']"   mode="legal_form" >
			<xsl:with-param name="title" select="'КПП'"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="//field[@name='email']" mode="legal_form" >
			<xsl:with-param name="title" select="'E-mail для доставки счета'"/>
			<xsl:with-param name="customer_email" select="$customer_email"/>
		</xsl:apply-templates>
	</xsl:template>


</xsl:stylesheet>
