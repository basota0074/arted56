<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">
	
	<xsl:template match="udata[@module='emarket' and @method='order']">		
        <h3>&emarket-mail-user-info;:</h3>
        <table border="1" cellspacing="0" cellpadding="5">
            <tbody>
                <xsl:apply-templates select="document(concat('uobject://',@id))//group[@name='saved_customer']/property" mode="customer"/>
            </tbody>
        </table>
        <h3>&emarket-mail-order-info;:</h3>
        <table border="1" cellspacing="0" cellpadding="5">
            <tbody>
                <tr>
                    <td><b>&emarket-mail-name;</b></td>
					<td><b>&emarket-mail-part;</b></td>
                    <td><b>&emarket-mail-amount;</b></td>
                    <td><b>&emarket-mail-price_per_unit;</b></td>
                    <td><b>&emarket-mail-price;</b></td>
                </tr>
                <xsl:apply-templates select="items/item" mode="order"/>
            </tbody>
        </table>
        <p><b>&emarket-summary-amount;:</b>&nbsp;<xsl:value-of select="summary/amount"/></p>
        <p><b>&emarket-summary-price;:</b>&nbsp;<xsl:value-of select="summary/price/actual"/>&nbsp;<xsl:value-of select="$infoPage/property[@name = 'currency']/value" /></p>
	</xsl:template>
    
    <xsl:template match="property" mode="customer"/>
    
    <xsl:template match="property[@name = 'fname' or @name = 'cust_fname']" mode="customer">
        <tr>
            <td><b>&emarket-customer-name;:</b></td>
            <td><xsl:value-of select="value"/></td>
        </tr>
	</xsl:template>
    
    <xsl:template match="property[@name = 'phone' or @name = 'cust_phone']" mode="customer">
        <tr>
            <td><b>&emarket-customer-phone;:</b></td>
            <td><xsl:value-of select="value"/></td>
        </tr>
	</xsl:template>
	
	<xsl:template match="property[@name = 'e-mail' or @name = 'email' or @name = 'cust_email']" mode="customer">
        <tr>
            <td><b>&emarket-customer-email;:</b></td>
            <td><xsl:value-of select="value"/></td>
        </tr>
	</xsl:template>
    
    <xsl:template match="property[@name = 'adres_dostavki' or @name = 'cust_adres_dostavki']" mode="customer">
        <tr>
            <td><b>&emarket-customer-address;:</b></td>
            <td><xsl:value-of select="value"/></td>
        </tr>
	</xsl:template>
    
    <xsl:template match="property[@name = 'info' or @name = 'cust_info']" mode="customer">
        <tr>
            <td><b>&emarket-customer-info;:</b></td>
            <td><xsl:value-of select="value"/></td>
        </tr>
	</xsl:template>
    
    <xsl:template match="item" mode="order">
		<xsl:variable name="item" select="document(concat('upage://',page/@id))/udata" />
        <tr>
            <td>
                <a href="{$_request_uri}{page/@link}">
					<xsl:value-of select="@name" />
				</a>
            </td>
			<td>
				<xsl:value-of select="$item//property[@name = 'artikul']/value"/>
            </td>
            <td>
                <xsl:value-of select="amount"/>
            </td>
            <td>
                <xsl:value-of select="price/actual"/>&nbsp;<xsl:value-of select="$infoPage/property[@name = 'currency']/value" />
            </td>
            <td>
                <xsl:value-of select="total-price/actual"/>&nbsp;<xsl:value-of select="$infoPage/property[@name = 'currency']/value" />
            </td>
        </tr>
	</xsl:template>
	
</xsl:stylesheet>