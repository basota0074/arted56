<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

	<xsl:template match="result[@method = 'ordersList']">
		<xsl:apply-templates select="document('udata://emarket/ordersList')/udata" />
	</xsl:template>
	
	<xsl:template match="udata[@method = 'ordersList']">
		<xsl:apply-templates select="items" mode="order" />
	</xsl:template>
	
	<xsl:template match="items" mode="order">
		<div class="text">
			<p>&emarket-no-orders;</p>
		</div>
	</xsl:template>
	
	<xsl:template match="items[count(item) != 0]" mode="order">
		<div class="order_list">
			<xsl:apply-templates select="item" mode="order"/>
		</div>
	</xsl:template>
	
	<xsl:template match="item" mode="order">
		<xsl:apply-templates select="document(concat('udata://emarket/order/', @id))/udata" />
	</xsl:template>

	<xsl:template match="udata[@module = 'emarket'][@method = 'order']">
		<xsl:variable name="object" select="document(concat('uobject://', @id))/udata" />
		<div class="order_item">
			<div class="order_title">
				<h3>
					<strong>
						<xsl:text>&emarket-order-number;&nbsp;</xsl:text>
						<xsl:value-of select="number"/>
					</strong>
					<xsl:text>&nbsp;&range-from;&nbsp;</xsl:text>
					<xsl:apply-templates select="$object//property[@name = 'order_date']">
						<xsl:with-param name="date_format" select="'d.m.Y'" />
					</xsl:apply-templates>
					<xsl:text>&nbsp;&in;&nbsp;</xsl:text>
					<xsl:apply-templates select="$object//property[@name = 'order_date']">
						<xsl:with-param name="date_format" select="'H:i'" />
					</xsl:apply-templates>
				</h3>
			</div>
			<div class="order_info">
				<div class="order_summary order_status">
					<strong>&emarket-order-status;:</strong>&nbsp;<xsl:value-of select="status/@name" />
				</div>
			</div>
			<div class="text">
				<table class="order_table">
					<colgroup>
						<col class="basket-col-2"/>
						<col class="basket-col-3"/>
						<col class="basket-col-4"/>
						<col class="basket-col-5"/>
						<col class="basket-col-6"/>
					</colgroup>
					<thead>
						<tr>
							<th>
								<xsl:text>&emarket-order-item-name;</xsl:text>
							</th>
							<th>
								<xsl:text>&emarket-order-item-art;</xsl:text>
							</th>
							<th>
								<xsl:text>&emarket-order-item-price;</xsl:text>
							</th>
							<th>
								<xsl:text>&emarket-order-item-amount;</xsl:text>
							</th>
							<th>
								<xsl:text>&emarket-order-item-sum;</xsl:text>
							</th>
						</tr>
					</thead>
					<tbody>
						<xsl:apply-templates select="items/item" mode="order-list"/>
					</tbody>
				</table>
			</div>
			<div class="order_info">
				<div class="order_summary order_price">
					<strong>&emarket-order-price;:</strong><xsl:apply-templates select="summary/price" />
				</div>
			</div>
			<xsl:variable name="invoice_link" 
					  select="document(concat('udata://emarket/getInvoiceLink/', @id))/udata" />
			<xsl:if test="$invoice_link">
				<div>
					<a href="{$invoice_link}" target="__blank">
						<xsl:text>&print-invoice;</xsl:text>
					</a>
				</div>
			</xsl:if>
		</div>
	</xsl:template>
	
	<xsl:template match="item" mode="order-list">
		<xsl:variable name="page" select="document(concat('upage://',page/@id))/udata/page" />
		<tr>
			<td class="text">
				<a href="{page/@link}">
					<xsl:value-of select="@name" />
				</a>
			</td>
			<td>
				<xsl:value-of select="$page//property[@name = 'artikul']/value" />
			</td>
			<td>
				<xsl:apply-templates select="price" />
			</td>
			<td>
				<xsl:apply-templates select="amount" />
			</td>
			<td>
				<xsl:apply-templates select="total-price" />
			</td>
		</tr>
	</xsl:template>

</xsl:stylesheet>