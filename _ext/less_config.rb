##
#
# Awestruct::Extensions:LessConfig is a classic type of awestruct extension.
# If configured in the project pipeline and site.yml it will configure
# the jborg_fonts_path and jborg_images_path Less variables based on site properties.
#
# Configuration:
#
# 1. configure the extension in the project pipeline.rb:
#    - add compass_config dependency:
#
#      require 'less_config'
#
#    - put the extension initialization in the initialization itself:
#
#      extension Awestruct::Extensions::LessConfig.new
#
# 2. This is an example site.yml configuration:
#
#    jborg_fonts_url: http://static.jboss.org/theme/fonts
#    jborg_images_url: http://static.jboss.org/theme/images	
#
##
module Awestruct
  module Extensions
    class LessConfig

      def execute(site)
        output = ''
        if !site.jborg_fonts_url.nil?
          output+= "@jborg_fonts_url: \"" + relative(site.jborg_fonts_url, site) + "\";\n"
        end
        if !site.jborg_images_url.nil?
          output+= "@jborg_images_url: \"" + relative(File.join(site.jborg_images_url , "common"), site) + "\" ;\n"
        end

        # Create a temporary file with the merged content.
        tmpOutputPath = File.join( site.config.tmp_dir , "config-variables.less")
        tmpOutputFile = File.new(tmpOutputPath,"w")
        tmpOutputFile.write(output)
        tmpOutputFile.close

      end

      def relative(href, site)
        if href.start_with?("http://") || href.start_with?("https://")
          # do not touch absolute links
          href
        else
          # bootstrap-community.css ends up in /stylesheets : be relative to that directory
          begin
            result = Pathname.new(File.join(site.config.dir, href)).relative_path_from(Pathname.new(File.join(site.config.stylesheets_dir, "bootstrap-community.css"))).to_s
            result
          rescue Exception => e
            $LOG.error "#{e}" if $LOG.error?
            $LOG.error "#{e.backtrace.join("\n")}" if $LOG.error?
          end
        end
      end

    end
  end
end
