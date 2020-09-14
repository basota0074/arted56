<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

	<xsl:template match="udata[@module = 'system' and @method = 'captcha']" />
	
	<xsl:template match="udata[@module = 'system' and @method = 'captcha' and count(url)]">
		<div class="required field captcha">
			<div class="captcha_input">
				<label>
					<span><xsl:text>&enter-captcha;:</xsl:text></span>
					<span class="required_star" title="&required-text;" ><span class="required_star_text">*</span></span>
				</label>
				<div class="field_div input">
					<input type="text" name="captcha" class="captcha_input"/>
				</div>
			</div>
			<div class="captcha_img">
				<img src="{url}{url/@random-string}" />
			</div>
			<div class="cleaner"/>
			<div class="webforms_error_text">
				&captcha-error-text;
			</div>
		</div>
	</xsl:template>

</xsl:stylesheet>