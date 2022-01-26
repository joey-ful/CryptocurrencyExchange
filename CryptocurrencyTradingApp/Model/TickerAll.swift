//
//  TickerAll.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/17.
//

import Foundation

struct TickerAll: Codable {
    let status: String
    let data: Data
    
    // MARK: - DataClass
    struct Data: Codable {
        let btc, eth, ltc, etc: Coin
        let xrp, bch, qtum, btg: Coin
        let eos, icx, trx, elf: Coin
        let omg, knc, glm, zil: Coin
        let waxp, powr, lrc, steem: Coin
        let strax, zrx, rep, xem: Coin
        let snt, ada, ctxc, bat: Coin
        let wtc, theta, loom, waves: Coin
        let dataTRUE, link, enj, vet: Coin
        let mtl, iost, tmtg, qkc: Coin
        let atolo, amo, bsv, orbs: Coin
        let tfuel, valor, con, ankr: Coin
        let mix, cro, fx, chr: Coin
        let mbl, mxc, fct, trv: Coin
        let dad, wom, soc, boa: Coin
        let fleta, sxp, cos, apix: Coin
        let el, basic, hive, xpr: Coin
        let vra, fit, egg, bora: Coin
        let arpa, ctc, apm, ckb: Coin
        let aergo, anw, cennz, evz: Coin
        let cyclub, srm, qtcon, uni: Coin
        let yfi, uma, aave, comp: Coin
        let ren, bal, rsr, nmr: Coin
        let rlc, uos, sand, gom2: Coin
        let ringx, bel, obsr, orc: Coin
        let pola, awo, adp, dvi: Coin
        let ghx, mir, mvc, bly: Coin
        let wozx, anv, grt, mm: Coin
        let biot, xno, snx, sofi: Coin
        let cola, nu, oxt, lina: Coin
        let map, aqt, wiken, ctsi: Coin
        let mana, lpt, mkr, sushi: Coin
        let asm, pundix, celr, lf: Coin
        let arw, msb, rly, ocean: Coin
        let bfc, alice, coti, cake: Coin
        let bnt, xvs, chz, axs: Coin
        let dai, matic, bake, velo: Coin
        let bcd, xlm, gxc, vsys: Coin
        let ipx, wicc, ont, luna: Coin
        let aion, meta, klay, ong: Coin
        let algo, jst, xtz, mlk: Coin
        let wemix, dot, atom, ssx: Coin
        let temco, hibs, burger, doge: Coin
        let ksm, ctk, xym, bnb: Coin
        let nft, sun, xec, pci: Coin
        let sol, boba, gala, btt: Coin
        let date: String

        enum CodingKeys: String, CodingKey {
            case btc = "BTC"
            case eth = "ETH"
            case ltc = "LTC"
            case etc = "ETC"
            case xrp = "XRP"
            case bch = "BCH"
            case qtum = "QTUM"
            case btg = "BTG"
            case eos = "EOS"
            case icx = "ICX"
            case trx = "TRX"
            case elf = "ELF"
            case omg = "OMG"
            case knc = "KNC"
            case glm = "GLM"
            case zil = "ZIL"
            case waxp = "WAXP"
            case powr = "POWR"
            case lrc = "LRC"
            case steem = "STEEM"
            case strax = "STRAX"
            case zrx = "ZRX"
            case rep = "REP"
            case xem = "XEM"
            case snt = "SNT"
            case ada = "ADA"
            case ctxc = "CTXC"
            case bat = "BAT"
            case wtc = "WTC"
            case theta = "THETA"
            case loom = "LOOM"
            case waves = "WAVES"
            case dataTRUE = "TRUE"
            case link = "LINK"
            case enj = "ENJ"
            case vet = "VET"
            case mtl = "MTL"
            case iost = "IOST"
            case tmtg = "TMTG"
            case qkc = "QKC"
            case atolo = "ATOLO"
            case amo = "AMO"
            case bsv = "BSV"
            case orbs = "ORBS"
            case tfuel = "TFUEL"
            case valor = "VALOR"
            case con = "CON"
            case ankr = "ANKR"
            case mix = "MIX"
            case cro = "CRO"
            case fx = "FX"
            case chr = "CHR"
            case mbl = "MBL"
            case mxc = "MXC"
            case fct = "FCT"
            case trv = "TRV"
            case dad = "DAD"
            case wom = "WOM"
            case soc = "SOC"
            case boa = "BOA"
            case fleta = "FLETA"
            case sxp = "SXP"
            case cos = "COS"
            case apix = "APIX"
            case el = "EL"
            case basic = "BASIC"
            case hive = "HIVE"
            case xpr = "XPR"
            case vra = "VRA"
            case fit = "FIT"
            case egg = "EGG"
            case bora = "BORA"
            case arpa = "ARPA"
            case ctc = "CTC"
            case apm = "APM"
            case ckb = "CKB"
            case aergo = "AERGO"
            case anw = "ANW"
            case cennz = "CENNZ"
            case evz = "EVZ"
            case cyclub = "CYCLUB"
            case srm = "SRM"
            case qtcon = "QTCON"
            case uni = "UNI"
            case yfi = "YFI"
            case uma = "UMA"
            case aave = "AAVE"
            case comp = "COMP"
            case ren = "REN"
            case bal = "BAL"
            case rsr = "RSR"
            case nmr = "NMR"
            case rlc = "RLC"
            case uos = "UOS"
            case sand = "SAND"
            case gom2 = "GOM2"
            case ringx = "RINGX"
            case bel = "BEL"
            case obsr = "OBSR"
            case orc = "ORC"
            case pola = "POLA"
            case awo = "AWO"
            case adp = "ADP"
            case dvi = "DVI"
            case ghx = "GHX"
            case mir = "MIR"
            case mvc = "MVC"
            case bly = "BLY"
            case wozx = "WOZX"
            case anv = "ANV"
            case grt = "GRT"
            case mm = "MM"
            case biot = "BIOT"
            case xno = "XNO"
            case snx = "SNX"
            case sofi = "SOFI"
            case cola = "COLA"
            case nu = "NU"
            case oxt = "OXT"
            case lina = "LINA"
            case map = "MAP"
            case aqt = "AQT"
            case wiken = "WIKEN"
            case ctsi = "CTSI"
            case mana = "MANA"
            case lpt = "LPT"
            case mkr = "MKR"
            case sushi = "SUSHI"
            case asm = "ASM"
            case pundix = "PUNDIX"
            case celr = "CELR"
            case lf = "LF"
            case arw = "ARW"
            case msb = "MSB"
            case rly = "RLY"
            case ocean = "OCEAN"
            case bfc = "BFC"
            case alice = "ALICE"
            case coti = "COTI"
            case cake = "CAKE"
            case bnt = "BNT"
            case xvs = "XVS"
            case chz = "CHZ"
            case axs = "AXS"
            case dai = "DAI"
            case matic = "MATIC"
            case bake = "BAKE"
            case velo = "VELO"
            case bcd = "BCD"
            case xlm = "XLM"
            case gxc = "GXC"
            case vsys = "VSYS"
            case ipx = "IPX"
            case wicc = "WICC"
            case ont = "ONT"
            case luna = "LUNA"
            case aion = "AION"
            case meta = "META"
            case klay = "KLAY"
            case ong = "ONG"
            case algo = "ALGO"
            case jst = "JST"
            case xtz = "XTZ"
            case mlk = "MLK"
            case wemix = "WEMIX"
            case dot = "DOT"
            case atom = "ATOM"
            case ssx = "SSX"
            case temco = "TEMCO"
            case hibs = "HIBS"
            case burger = "BURGER"
            case doge = "DOGE"
            case ksm = "KSM"
            case ctk = "CTK"
            case xym = "XYM"
            case bnb = "BNB"
            case nft = "NFT"
            case sun = "SUN"
            case xec = "XEC"
            case pci = "PCI"
            case sol = "SOL"
            case boba = "BOBA"
            case gala = "GALA"
            case btt = "BTT"
            case date
        }
        
        struct Coin: Codable, Hashable {
            let openingPrice, closingPrice, minPrice, maxPrice: String
            let unitsTraded, accTradeValue, prevClosingPrice, unitsTraded24H: String
            let accTradeValue24H, fluctate24H, fluctateRate24H: String

            enum CodingKeys: String, CodingKey {
                case openingPrice = "opening_price"
                case closingPrice = "closing_price"
                case minPrice = "min_price"
                case maxPrice = "max_price"
                case unitsTraded = "units_traded"
                case accTradeValue = "acc_trade_value"
                case prevClosingPrice = "prev_closing_price"
                case unitsTraded24H = "units_traded_24H"
                case accTradeValue24H = "acc_trade_value_24H"
                case fluctate24H = "fluctate_24H"
                case fluctateRate24H = "fluctate_rate_24H"
            }

            static func == (lhs: TickerAll.Data.Coin, rhs: TickerAll.Data.Coin) -> Bool {
                return lhs.openingPrice == rhs.openingPrice
                && lhs.closingPrice == rhs.closingPrice
                && lhs.unitsTraded == rhs.unitsTraded
            }

            func hash(into hasher: inout Hasher) {
                hasher.combine(openingPrice)
                hasher.combine(closingPrice)
                hasher.combine(unitsTraded)
            }
        }

    }
}
