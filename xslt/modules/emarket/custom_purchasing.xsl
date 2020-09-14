<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

	<!-- Сюда попадаем при оформлении заказа -->
	<xsl:template match="result[@method = 'order_create']">
		<xsl:apply-templates select="document('udata://emarket/order_create')/udata" />
	</xsl:template>
	
	<!-- Если в системе отключены платёжные системы, то редиректим на successful -->
	<xsl:template match="udata[@module = 'emarket' and @method = 'order_create']">
		<xsl:apply-templates select="document('udata://content/redirect/(/emarket/purchase/result/successful/)')" />
	</xsl:template>
	
	<!-- Если в системе есть платёжные системы, то показываем варианты оплаты -->
	<xsl:template match="udata[@module = 'emarket' and @method = 'order_create'][paysystem]">
		<xsl:apply-templates select="document(concat('udata://content/redirect/(/emarket/order_paysystem/', order_id, '/)'))" />
	</xsl:template>
	
	<!-- Сюда попадаем при выборе способа оплаты заказа -->
    <xsl:template match="result[@method = 'order_paysystem']">
        <xsl:apply-templates select="document('udata://emarket/order_paysystem/')/udata" />
    </xsl:template>
	
	<!-- Отображаем список ссылок вариантов оплаты -->
	<xsl:template match="udata[@module = 'emarket' and @method = 'order_paysystem']">
		<div class="order_paysystem">
			<xsl:apply-templates select="system" mode="custom_paysystems" />
		</div>
	</xsl:template>
	
	<!-- Один вариант оплаты -->
	<xsl:template match="system" mode="custom_paysystems">
		<div class="order_paysystem_item" umi:object-id="{@id}">
			<h3 title="{@caption}" umi:empty="&emarket-paysystem-name;" umi:field-name="name" umi:field-type="string">
				<strong><xsl:value-of select="@caption" disable-output-escaping="yes" /></strong>
			</h3>
			<xsl:variable name="description" select="document(concat('uobject://', @id))//property[@name='description']" />
			<div id="paysystem_description_{@id}_{generate-id()}" class="text" umi:empty="&emarket-paysystem-description;" umi:field-name="description" umi:field-type="wysiwyg">
				<xsl:value-of select="$description/value"  disable-output-escaping="yes" />
			</div>
			<div class="paysystem_buttons">
				<a class="all_system_buttons" href="{.}">
					&emarket-order-paysystem-pay;
				</a>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template match="purchasing[@stage = 'result']">
        <div id="order_failed_text_{$infoPageId}_{generate-id()}" class="text" umi:element-id="{$infoPageId}" umi:empty="&empty;" umi:field-name="order_failed_text" umi:field-type="string">
            <xsl:apply-templates select="$infoPage/property[@name = 'order_failed_text']" />
        </div>
    </xsl:template>

    <xsl:template match="purchasing[@stage = 'result' and @step = 'successful']">
        <div id="order_success_text_{$infoPageId}_{generate-id()}" class="text" umi:element-id="{$infoPageId}" umi:empty="&empty;" umi:field-name="order_success_text" umi:field-type="string">
            <xsl:apply-templates select="$infoPage/property[@name = 'order_success_text']" />
        </div>
    </xsl:template>
	
	<xsl:template match="purchasing[@stage = 'required'][@step = 'personal']">
		<form class="site_form purchase_fields" enctype="multipart/form-data" method="post" action="/emarket/purchase/required/personal/do/">
			<fieldset>
				<xsl:apply-templates select="document(concat('udata://data/getEditForm/', customer-id))/udata" />
				<xsl:call-template name="personal_data_notice" />
			</fieldset>
			<fieldset>
				<div class="submit">
					<input class="all_system_buttons" type="submit" value="&begin-purchase;" />
				</div>
			</fieldset>
		</form>
	</xsl:template>
	
</xsl:stylesheet>
