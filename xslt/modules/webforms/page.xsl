<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:php="http://php.net/xsl"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:umi="http://www.umi-cms.ru/TR/umi"
	extension-element-prefixes="php"
	exclude-result-prefixes="php">
	
	<!--Cтраница контактов-->
    <xsl:template match="result[@module = 'webforms'][@method = 'page']">
        <xsl:apply-templates select="page/properties" mode="new_contacts_form"/>
        <div class="contacts_page_h2 h2" umi:element-id="{$infoPageId}" umi:empty="&empty;" umi:field-name="feedback_title" umi:field-type="string">
            <xsl:apply-templates select="$infoPage/property[@name = 'feedback_title']" />
        </div>
        <xsl:apply-templates select="document(concat('udata://webforms/add/', .//property[@name = 'form_id']/value))/udata" mode="feedback"/>
    </xsl:template>
	
	 <xsl:template match="result[@module = 'webforms' and @method = 'page']/page/properties" mode="new_contacts_form">
        <div umi:element-id="{$pageId}">
            <table class="contact_info">
				<tr class="contact_info_block contact_address">
					<xsl:if test="not(//property[@name ='address']/value)">
						<xsl:attribute name="class">contact_info_block contact_address hidden</xsl:attribute>
					</xsl:if>
					<td class="contact_title">
						<div umi:element-id="{$pageId}" umi:empty="&feedback-address-title;" umi:field-name="address_title" umi:field-type="string">
							<xsl:apply-templates select="//property[@name = 'address_title']" />
						</div>
					</td>
					<td class="contact_value">
						<div umi:element-id="{$pageId}" umi:field-name="address" umi:field-type="string" umi:empty="&feedback-address;">
							<xsl:apply-templates select="//property[@name ='address']" />
						</div>
					</td>
				</tr>
				<tr class="contact_info_block contact_time">
					<xsl:if test="not(//property[@name ='time']/value)">
						<xsl:attribute name="class">contact_info_block contact_time hidden</xsl:attribute>
					</xsl:if>
					<td class="contact_title">
						<div umi:element-id="{$pageId}" umi:empty="&feedback-time-title;" umi:field-name="time_title" umi:field-type="string">
							<xsl:apply-templates select="//property[@name = 'time_title']" />
						</div>
					</td>
					<td class="contact_value">
						<div umi:element-id="{$pageId}" umi:field-name="time" umi:field-type="string" umi:empty="&feedback-time;">
							<xsl:apply-templates select="//property[@name ='time']" />
						</div>
					</td>
				</tr>
				<tr class="contact_info_block contact_phone">
					<xsl:if test="not(//property[@name ='full_phone']/value)">
						<xsl:attribute name="class">contact_info_block contact_phone hidden</xsl:attribute>
					</xsl:if>
					<td class="contact_title">
						<div umi:element-id="{$pageId}" umi:empty="&feedback-phones-title;" umi:field-name="full_phone_title" umi:field-type="string">
							<xsl:apply-templates select="//property[@name = 'full_phone_title']" />
						</div>
					</td>
					<td class="contact_value">
						<div umi:element-id="{$pageId}" umi:field-name="full_phone" umi:field-type="string" umi:empty="&feedback-phones;">
							<xsl:apply-templates select="//property[@name ='full_phone']" />
						</div>
					</td>
				</tr>
				<tr class="contact_info_block contact_fax">
					<xsl:if test="not(//property[@name ='fax']/value)">
						<xsl:attribute name="class">contact_info_block contact_fax hidden</xsl:attribute>
					</xsl:if>
					<td class="contact_title">
						<div umi:element-id="{$pageId}" umi:empty="&feedback-fax-title;" umi:field-name="fax_title" umi:field-type="string">
							<xsl:apply-templates select="//property[@name = 'fax_title']" />
						</div>
					</td>
					<td class="contact_value">
						<div umi:element-id="{$pageId}" umi:field-name="fax" umi:field-type="string" umi:empty="&feedback-fax;">
							<xsl:apply-templates select="//property[@name ='fax']" />
						</div>
					</td>
				</tr>
				<tr class="contact_info_block contact_skype">
					<xsl:if test="not(//property[@name ='skype']/value)">
						<xsl:attribute name="class">contact_info_block contact_skype hidden</xsl:attribute>
					</xsl:if>
					<td class="contact_title">
						<div umi:element-id="{$pageId}" umi:empty="&feedback-skype-title;" umi:field-name="skype_title" umi:field-type="string">
							<xsl:apply-templates select="//property[@name = 'skype_title']" />
						</div>
					</td>
					<td class="contact_value">
						<div umi:element-id="{$pageId}" umi:empty="&feedback-skype;" umi:field-name="skype" umi:field-type="string" >
							<xsl:if test="//property[@name ='skype']/value">
								<a href="skype:{//property[@name ='skype']/value}"><xsl:apply-templates select="//property[@name ='skype']" /></a>
							</xsl:if>
						</div>
					</td>
				</tr>
				<tr class="contact_info_block contact_email">
					<xsl:if test="not(//property[@name ='email']/value)">
						<xsl:attribute name="class">contact_info_block contact_email hidden</xsl:attribute>
					</xsl:if>
					<td class="contact_title">
						<div umi:element-id="{$pageId}" umi:empty="&feedback-email-title;" umi:field-name="email_title" umi:field-type="string">
							<xsl:apply-templates select="//property[@name = 'email_title']" />
						</div>
					</td>
					<td class="contact_value">
						<div umi:element-id="{$pageId}" umi:field-name="email" umi:field-type="string" umi:empty="&feedback-email;">
							<xsl:if test="//property[@name ='email']/value">
								<a href="mailto:{//property[@name ='email']/value}"><xsl:apply-templates select="//property[@name ='email']" /></a>
							</xsl:if>
						</div>
					</td>
				</tr>
            </table>
			<xsl:if test="not($userType = 'guest')">
				<div class="hidden">
					<xsl:if test="not(//property[@name ='yandexmap']/value)">
						<div class="text">
							<p>
								<a target="blank" href="http://api.yandex.ru/maps/tools/constructor/">&no-yamap;</a>
							</p>
						</div>
					</xsl:if>
					<div umi:element-id="{$pageId}" umi:field-name="yandexmap" umi:field-type="text" umi:empty="&empty-yamap;">
						<xsl:value-of select="//property[@name ='yandexmap']/value" disable-output-escaping="yes" />
					</div>
				</div>
			</xsl:if>
			<xsl:apply-templates select="//property[@name ='yandexmap']" mode="yandex_map" />
			<div id="text_{$pageId}_{generate-id()}" umi:element-id="{$pageId}" class="text" umi:field-name="text" umi:field-type="wysiwyg" umi:empty="&empty-page-content;">
				<xsl:apply-templates select="//property[@name ='text']" />
			</div>
        </div>
    </xsl:template>

	<xsl:template match="property" mode="yandex_map" >
		<div class="code_pre yandex_map">
			<xsl:value-of select="php:function('htmlspecialchars_decode', string(value))" disable-output-escaping="yes" />
		</div>
	</xsl:template>

</xsl:stylesheet>