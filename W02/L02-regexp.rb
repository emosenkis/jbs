#!/bin/env ruby

def is_phone?(string)
	# Check for valid US phone number - optional country code, area code
	# with optional parentheses, area code, first 3 and last four digits,
	# each separated by dash, space, or neither
	string =~ /\A(?:+1|1|)(?:-| |)(\(\d{3}\)|\d{3})(?:-| |)\d{3}(?:-| |)\d{4}\z/
end

def course_num?(string)
	# Check for valid Brandeis course number - subject code, 1-3 digit
	# number, course letter
	string =~ /\A(?:AAAS|AMST|AMST|AMST\/SOC|ANTH|ANTH\/ENG|ANTH\/NEJ|ARBC|BCBP|BCHM|BCSC|BIOL|BIOP|BIOT|BIPH|BISC|BUS|CBIO|CHEM|CHIN|CHSC|CLAS|CLAS\/FA|CLAS\/THA|COEX|COML|COML\/END|COMP|CONT|COSI|CP|EAS|ECON|ECON\/FA|ECON\/FIN|ECS|ED|EL|ENG|ENG\/HIST|ENVS|ESL|FA|FILM|FIN|FREN|GECS|GER|GRK|GS|HBRW|HECS|HISP|HIST|HOID|HRNS|HRNS\/HS|HS|HSSP|HUM|IECS|IGS|IGS\/LGLS|IIM|IMES|INET|ITAL|JAPN|JOUR|LALS|LAT|LGLS|LGLS\/POL|LING|MATH|MEVL|MUS|NBIO|NEJS|NEJS\/SOC|NEUR|NPHY|NPSY|PAX|PE|PEER|PHIL|PHSC|PHYS|POL|PSYC|QBIO|RECS|RECS\/THA|REES|REL|REL\/SAS|RUS|SAS|SJSP|SOC|SYS|THA|UWS|WMGS|YDSH) ?[1-9]\d{0,2}(?:[A-G]|AJ|BJ)\z/
end

def legal_url?(string)
	# Check for valid URL - protocol (http or https), optional subdomains,
	# toplevel domain, optional port specifier, optional path elements
	string =~ /\Ahttps?:\/\/(?:[a-z0-9_-]\.)*[a-z0-9_-]+(?::[1-9][0-9]*)?(?:\/.*)\z/i
end


