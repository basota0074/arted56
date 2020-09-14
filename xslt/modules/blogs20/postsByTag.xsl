<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

    <xsl:template match="result[@module = 'blogs20'][@method = 'postsByTag']">
        <div class="blog">
            <xsl:apply-templates select="document('udata://blogs20/postsByTag/')/udata" />
        </div>
    </xsl:template>

</xsl:stylesheet>