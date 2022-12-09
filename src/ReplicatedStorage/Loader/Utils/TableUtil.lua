local TableUtil = {}

function TableUtil.DictionaryLength(dictionary: any): number
	local len = 0

	for _, _ in pairs(dictionary) do
		len += 1
	end

	return len
end

return TableUtil
