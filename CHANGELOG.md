CHANGELOG
=========

| Symbol | Meaning             |
|--------|---------------------|
| 🌟     | New function        |
| 🛠     | Improvement changes |
| 🐞     | Bug fixing          |

## Upcoming version ##

## 1.4.1 (2026-06-18) ##

- 🛠 Send `NULL` prices on closed stations instead of empty list
- 🐞 Adopt new price fuel types to report module

## 1.4.0 (2026-01-12) ##

- 🛠 Make fuel types generic
- 🌟 Add Danish Krone (DKK) currency
- 🌟 Add price snapshots (history) API
- 🐞 Use dynamic auto-closing value based on origin
- 🐞 Fix auto-closing, when only a single price is outdated
- 🐞 Don't responde outdated prices

## 1.3.0 (2025-08-11) ##

- 🛠 Automatically forward price reports to origin
- 🌟 Add price storing for price history ([#17](https://github.com/tankste/backend/issues/17))
- 🌟 Add cronjob to automatically close stations when the prices are no longer updated ([#15](https://github.com/tankste/backend/issues/15))

## 1.2.1 (2025-01-03) ##

- 🐞 Fix not recognized station info priority by `get_by_station_id`

## 1.2.0 (2024-10-17) ##

- 🌟 Add cockpit (aka admin panel) to mange data
    - Stations
    - Station infos
    - Open times
    - Reports

## 1.1.3 (2024-05-17) ##

- 🛠 Fallback to sunday open times on holidays, because most stations don't provide holiday open times

## 1.1.2 (2024-04-24) ##

- 🛠 Add more sponsor products

## 1.1.1 (2024-04-20) ##

- 🐞 Clean constrains & indexes after table migrations

## 1.1.0 (2024-04-19) ##

- 🛠 Allow multiple data origins for stations, prices & related data ([#7](https://github.com/tankste/backend/issues/7))
- 🌟 Add currency ([#8](https://github.com/tankste/backend/issues/8))

## 1.0.0 (2024-03-03) ##

* 🌟 Add report api
* 🌟 Add sponsor api
* 🌟 Add fill api
* 🌟 Add station api
* 🌟 Initial setup
