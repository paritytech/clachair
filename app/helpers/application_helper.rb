# frozen_string_literal: true

module ApplicationHelper
  def markdown(text)
    options = {
      filter_html: true,
      hard_wrap: true,
      link_attributes: { rel: "nofollow", target: "_blank" },
      space_after_headers: true,
      fenced_code_blocks: true
    }

    extensions = {
      autolink: true,
      superscript: true,
      disable_indented_code_blocks: true
    }

    renderer = Redcarpet::Render::HTML.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)

    markdown.render(text).html_safe
  end

  def decorate_date(date)
    date.strftime("%A, %b %d, %Y, %H:%M:%S, %Z")
  end
end
