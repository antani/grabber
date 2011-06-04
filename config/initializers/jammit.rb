unless Rails.env.development?
  require 'fileutils'
  output_folder = Rails.root.join("tmp", "jammit", "assets")
  FileUtils.mkdir_p(output_folder)

  # Heroku specific hack.
  Jammit::Packager.class_eval do
    def glob_files_with_heroku_hack(glob)
      paths = glob_files_without_heroku_hack(glob)
      # Heroku has a magical "public/javascripts/all.js" file. It is a Mystery.
      paths.reject { |path| path =~ /javascripts\/all.js$/ }
    end
    alias_method_chain :glob_files, :heroku_hack
  end

  Jammit.package! :output_folder => output_folder

  Rails.configuration.middleware.insert_before('Rack::Sendfile', 'Rack::Static',
    :urls => ['/assets'],
    :root => "#{Rails.root}/tmp/jammit")
end
