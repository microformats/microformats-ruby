require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "nokogiri"
require "open-uri"
require "pp"

RSpec::Core::RakeTask.new(:spec)
task :default => [:spec]

namespace :specs do
  task :update do
    sources = [
      { dir: "microformats.org",
        urls: ["http://microformats.org/wiki/microformats-2"],
        html_selector: ".source-html4strict",
        json_selector: ".source-javascript",
        html_method: "inner_text"
      },
      { dir: "microformat2-node.jit.su",
        urls: [
          "http://microformat2-node.jit.su/h-adr.html",
          "http://microformat2-node.jit.su/h-card.html",
          "http://microformat2-node.jit.su/h-entry.html",
          "http://microformat2-node.jit.su/h-event.html",
          "http://microformat2-node.jit.su/h-geo.html",
          "http://microformat2-node.jit.su/h-news.html",
          "http://microformat2-node.jit.su/h-org.html",
          "http://microformat2-node.jit.su/h-product.html",
          "http://microformat2-node.jit.su/h-recipe.html",
          "http://microformat2-node.jit.su/h-resume.html",
          "http://microformat2-node.jit.su/h-review-aggregate.html",
          "http://microformat2-node.jit.su/h-review.html",
          "http://microformat2-node.jit.su/rel.html",
          "http://microformat2-node.jit.su/includes.html",
        ],
        html_selector: ".e-x-microformat",
        json_selector: ".language-json",
        html_method: "inner_html"
      }
    ]

    sources.each do |source|
      source[:urls].each do |url|
        document = Nokogiri::HTML(open(url).read)
        html = document.css(source[:html_selector]).map { |e| e.send(source[:html_method]) }
        json = document.css(source[:json_selector]).map { |e| e.inner_text }

        name = url.split("/").last.gsub(/[.]\w+/, "")
        path = File.join "spec/support/cases", source[:dir], name

        FileUtils.mkdir_p(path)

        ([html.length, json.length].min).times do |index|

          File.open(File.join(path, "#{name}-#{index}.html"), "w") do |f|
            f.write "<!-- #{url} -->\n"
            f.write html[index]
          end

          File.open(File.join(path, "#{name}-#{index}.js"), "w") do |f|
            f.write "// #{url}\n"
            f.write json[index]
          end
        end

      end
    end
  end
end
