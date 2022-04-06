module ApplicationHelper
    def locale
        I18n.locale == :en ? "Inglês norte-americano" : "portugues-BR"
    end
end
