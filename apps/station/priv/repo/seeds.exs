[
	%{name: "tankste! - Deine Tankpreis App", short_name: "tankste!", icon_image_url: "https://tankste.app/assets/images/tankste/icon.png", image_url: "https://tankste.app/assets/images/tankste/logo.png", website_url: "https://tankste.app/"},
]
|> Enum.map(fn p -> Tankste.Station.Origins.insert(p) end)

[
	%{key: "de", name: "Deutschland"},
	%{key: "de_bw", name: "Baden-Württemberg"},
	%{key: "de_by", name: "Bayern"},
	%{key: "de_be", name: "Berlin"},
	%{key: "de_bb", name: "Brandenburg"},
	%{key: "de_hb", name: "Bremen"},
	%{key: "de_hh", name: "Hamburg"},
	%{key: "de_he", name: "Hessen"},
	%{key: "de_mv", name: "Mecklenburg-Vorpommern"},
	%{key: "de_ni", name: "Niedersachsen"},
	%{key: "de_nw", name: "Nordrhein-Westfalen"},
	%{key: "de_rp", name: "Rheinland-Pfalz"},
	%{key: "de_sl", name: "Saarland"},
	%{key: "de_sn", name: "Sachsen"},
	%{key: "de_st", name: "Sachsen-Anhalt"},
	%{key: "de_sh", name: "Schleswig-Holstein"},
	%{key: "de_th", name: "Thüringen"}
]
|> Enum.map(fn p -> Tankste.Station.Areas.create(p) end)
