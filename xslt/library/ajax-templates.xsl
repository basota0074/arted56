<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">
	
	<xsl:template match="udata" mode="ajax-order-form">
		<div id="order_form_wrapper">
			<div id="order_form_title" umi:field-name="order_form_title" umi:field-type="string" umi:empty="&empty;" umi:element-id="{$infoPageId}">
				<xsl:value-of select="$infoPageForm/property[@name = 'order_form_title']/value" />
			</div>
			<xsl:if test="$admin = 1">
				<div class="admin-info">
					<div class="hidden-text">
						<p>&order-form-admin-text;</p>
					</div>
				</div>
			</xsl:if>
			<form id="order_form" method="post">
				<fieldset>
					<input type="hidden" value="http://{$domain}{page/@link}" name="page_link"/>
                    <input type="hidden" value="{$domain}" name="domain"/>
					<input type="hidden" value="{$infoPageForm/property[@name = 'order_name_title']/value}" name="order_name_title"/>
					<input type="hidden" value="{$infoPageForm/property[@name = 'order_phone_title']/value}" name="order_phone_title"/>
					<input type="hidden" value="{$infoPageForm/property[@name = 'order_message_title']/value}" name="order_message_title"/>
                    <table>
                        <tbody>
                            <tr class="fieldset_tr order_name">
                                <td>
                                    <div class="label" umi:field-name="order_name_title" umi:field-type="string" umi:empty="&empty;" umi:element-id="{$infoPageId}">
                                        <xsl:value-of select="$infoPageForm/property[@name = 'order_name_title']/value" />
                                    </div>
                                </td>
                                <td class="order_form_value">
                                    <input type="text" name="order_name"/>
                                    <div class="order_form_error_text">
                                        &order-form-error-text;
                                    </div>
                                </td>
                            </tr>
                            <tr class="fieldset_div order_phone">
                                <td>
                                    <div class="label" umi:field-name="order_phone_title" umi:field-type="string" umi:empty="&empty;" umi:element-id="{$infoPageId}">
                                        <xsl:value-of select="$infoPageForm/property[@name = 'order_phone_title']/value" />
                                    </div>
                                </td>
                                <td class="order_form_value">
                                    <input type="text" name="order_phone"/>
                                    <div class="order_form_error_text">
                                        &order-form-error-text;
                                    </div>
                                </td>
                            </tr>
                            <tr class="fieldset_div order_message">
                                <td>
                                    <div class="label" umi:field-name="order_message_title" umi:field-type="string" umi:empty="&empty;" umi:element-id="{$infoPageId}">
                                        <xsl:value-of select="$infoPageForm/property[@name = 'order_message_title']/value" />
                                    </div>
                                </td>
                                <td class="order_form_value">
                                    <textarea name="order_message"/>
                                    <div class="order_form_error_text">
                                        &order-form-error-text;
                                    </div>
                                </td>
                            </tr>

							<tr class="fieldset_div pdn">
								<xsl:call-template name="personal_data_notice" />
							</tr>

							<tr>
								<td class="order_submit_table_tr" colspan="2">
									<table class="order_submit_table">
										<tbody>
											<tr>
												<td>
													<div class="order_form_success" umi:field-name="order_form_success" umi:field-type="string" umi:empty="&empty;" umi:element-id="{$infoPageId}">
														<xsl:value-of select="$infoPageForm/property[@name = 'order_form_success']/value" />
													</div>
												</td>
												<td>
													<a id="order_submit" class="all_system_buttons" title="&send;">&send;</a>
												</td>
											</tr>
										</tbody>
									</table>
								</td>
							</tr>
                        </tbody>
                    </table>
				</fieldset>
			</form>
		</div>
	</xsl:template>
	
</xsl:stylesheet>
