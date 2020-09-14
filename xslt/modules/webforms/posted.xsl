<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

    <xsl:param name="template" />

    <xsl:template match="result[@module = 'webforms'][@method = 'posted']">
        <div class="text">
            <p>
                <xsl:apply-templates select="document(concat('udata://webforms/posted/', $template,'/'))/udata" />
            </p>
        </div>
        <div>
			<a class="all_system_buttons system_back" href="{$_http_referer}">&back;</a>
		</div>
    </xsl:template>

    <xsl:template match="udata[@module = 'webforms'][@method = 'posted']">
        <xsl:value-of select="text" disable-output-escaping="yes" />
    </xsl:template>

</xsl:stylesheet>