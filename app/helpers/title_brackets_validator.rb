class TitleBracketsValidator < ActiveModel::Validator

    def validate(record)

        if !record.title.match(Regexp.new('\(\)|\[\]|\{\}')).nil? 
            record.errors.add :base, 'Empty bracelets'
        end

        if !record.title.match(Regexp.new('\(|\[|\{')).nil? && record.title.match(Regexp.new('\(.*\)|\[.*\]|\{.*\}')).nil?
            record.errors.add :base, 'No close'
        end

        if !record.title.match(Regexp.new('\)|\]|\}')).nil? && record.title.match(Regexp.new('\(.*\)|\[.*\]|\{.*\}')).nil?
            record.errors.add :base, 'No open'
        end

        if record.title.gsub(Regexp.new('[^\(]'), '').length != record.title.gsub(Regexp.new('[^\)]'), '').length || record.title.gsub(Regexp.new('[^\{]'), '').length != record.title.gsub(Regexp.new('[^\}]'), '').length || record.title.gsub(Regexp.new('[^\[]'), '').length != record.title.gsub(Regexp.new('[^\]]'), '').length
            record.errors.add :base, 'non matching brackets'
        end

    end
end