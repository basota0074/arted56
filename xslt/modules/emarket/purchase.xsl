<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

	<xsl:include href="purchase/required.xsl" />
	<xsl:include href="purchase/delivery.xsl" />
	<xsl:include href="purchase/payment.xsl" />
	
	<xsl:template match="result[@method = 'purchase']">
        <xsl:apply-templates select="document('udata://emarket/purchase')/udata" />
    </xsl:template>
	
	<xsl:template match="purchasing[@stage = 'result']">
        <div id="order_failed_text_{$infoPageId}_{generate-id()}" class="text" umi:element-id="{$infoPageId}" umi:empty="&empty;" umi:field-name="order_failed_text" umi:field-type="string">
            <xsl:apply-templates select="$infoPage/property[@name = 'order_failed_text']" />
        </div>
    </xsl:template>

	<xsl:variable name="domain" select="/result/@domain" />

    <xsl:template match="purchasing[@stage = 'result' and @step = 'successful']">
        <div id="order_success_text_{$infoPageId}_{generate-id()}" class="text" umi:element-id="{$infoPageId}" umi:empty="&empty;" umi:field-name="order_success_text" umi:field-type="string">
            <xsl:apply-templates select="$infoPage/property[@name = 'order_success_text']" />
        </div>
		<p>
			&orders-history;
			<xsl:text> </xsl:text>
			<a href="/emarket/personal/default/{personal_params}/">&personal-account;</a>
		</p>
		<xsl:if test="invoice_link">
			<script>
				jQuery(document).ready(function(){
					var url = "http://" + "<xsl:value-of select="$domain" />" + "<xsl:value-of select="invoice_link" />";
					var popupParams = "width=650,height=650,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=yes,resizable=no";
					var popup = window.open(url, 'invoice_win', popupParams);
				});
			</script>
		</xsl:if>
    </xsl:template>
	
</xsl:stylesheet>