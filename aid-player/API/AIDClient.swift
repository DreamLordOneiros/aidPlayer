//
//  AIDClient.swift
//  aid-player
//
//  Created by Javier Hernández on 8/22/19.
//  Copyright © 2019 Javier Hernández. All rights reserved.
//

import SwiftSoup
import Alamofire

class AIDClient {
    static let shared = AIDClient()
//    static let baseURL = "https://www.animeid.tv/one-piece"
//    static let baseURL = "https://www.animeid.tv/kimetsu-no-yaiba"
    static let baseURL = "https://www.animeid.tv"
    
    private init(){}
    
    func getLatestChapter(completionHandler: @escaping (Element) -> Void)  {
        AF.request(AIDClient.baseURL).responseJSON { response in
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                do {
                    let doc: Document = try SwiftSoup.parse(utf8Text)
                    let latestChapter = try doc.getElementById("listado")?.children().first()
                    completionHandler(latestChapter!)
                } catch {
                    print("error")
                }
            }
        }
    }
    
    func getAnimeCard(with path:String, completionHandler: @escaping (AnimeCard) -> Void) {
        AF.request(AIDClient.baseURL + path).responseJSON {[unowned self] response in
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                do {
                    let doc: Document = try SwiftSoup.parse(utf8Text)
                    let animeCard = try doc.getElementById("anime")
                    
                    if let cover = try? animeCard?.getElementsByClass("cover").attr("src"), let nameRomani = try? animeCard?.getElementsByTag("h1").first()?.text(), let nameKanji = try? animeCard?.getElementsByTag("h2").first()?.text(), let sinopsis = try? animeCard?.getElementsByClass("sinopsis").text(), let tags = try? animeCard?.getElementsByClass("tags"), let status = try? animeCard?.getElementsByClass("status-left"), let latestChapter = try doc.getElementById("listado")?.children().first() {
                        let newCard = AnimeCard(nameRomani: nameRomani, nameKanji: nameKanji, cover: cover, status: status, sinopsis: sinopsis, tags: tags, latest: self.parseChapters(element: latestChapter))
                        completionHandler(newCard)
                    }
                } catch {
                    print("error")
                }
            }
        }
    }
    
    func parseChapters(element:Element) -> Chapters {
        if let lastChapter = try? element.getElementsByTag("strong").text(), let date = try? element.getElementsByClass("right").text(), let path = try? element.select("a").first()?.attr("href") {
            let chapterInt = String(lastChapter.split(separator: " ").last!)
            let chapter = Chapters(lastChapter: Int(chapterInt), publishDate: date, hRef: path.replacingOccurrences(of: "\(chapterInt)", with: ""))
            return chapter
        }
        return Chapters(lastChapter: 0, publishDate: "", hRef: "")
    }
    
    func parseTopAnime(element:Element) -> Anime {
        if let animeName = try? element.getElementsByTag("strong").text(), let date = try? element.getElementsByTag("time").first()?.attr("datetime"), let path = try? element.select("a").first()?.attr("href") {
            let topAnime = Anime(animeName: animeName, lastChapter: String(path.split(separator: "-").last!), publishDate: date, pathToMain: stripMainPath(chapterPath: path), pathToLatest: path, cover: "")
            return topAnime
        }
        return Anime(animeName: "", lastChapter: "", publishDate: "", pathToMain: "", pathToLatest: "", cover: "")
    }
    
    func parseWeekAnime(element: Element) -> Anime {
        if let animeName = try? element.getElementsByTag("header").text(), let cover = try? element.getElementsByTag("img").first()?.attr("src"), let path = try? element.select("a").first()?.attr("href") {
            let topAnime = Anime(animeName: animeName, lastChapter: String(path.split(separator: "-").last!), publishDate: "",pathToMain:  stripMainPath(chapterPath: path), pathToLatest: path, cover: cover)
            return topAnime
        }
        return Anime(animeName: "", lastChapter: "", publishDate: "", pathToMain: "", pathToLatest: "", cover: "")
    }
    
    func getServers(forPath path:String, completionHandler: @escaping ([String]) -> Void) {
        AF.request(AIDClient.baseURL + path).responseJSON { [unowned self] response in
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                do {
                    let doc: Document = try SwiftSoup.parse(utf8Text)
                    let serverNodes = try doc.getElementsByClass("parte")
                    var serversArray = [String]()
                    for element:Element in serverNodes {
                        let serverData = try? element.attr("data")
                        let results = self.matches(for: "src=\\\\u0022\\S*\\\\u0022", in: serverData!)
                        if let sanitizedString = results.first?.replacingOccurrences(of: "src=\\u0022", with: "").replacingOccurrences(of: "\\u0022", with: "").replacingOccurrences(of: "\\/", with: "/") {
                            if sanitizedString.contains("?") && !sanitizedString.contains("netu") {
                                let cleanedString = sanitizedString.split(separator: "?").first
                                serversArray.append(String(cleanedString!))
                            } else if (!sanitizedString.contains("https:")) {
                                let updatedString = sanitizedString.replacingOccurrences(of: "//", with: "https://")
                                serversArray.append(updatedString)
                            } else {
                                serversArray.append(sanitizedString)
                            }
                        }
                    }
                    completionHandler(serversArray)
                } catch {
                    print("error")
                    completionHandler([String]())
                }
            }
        }
    }
    
    func matches(for regex: String, in text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    func getTop12(completionHandler: @escaping ([Anime]) -> Void) {
        AF.request(AIDClient.baseURL).responseJSON {[unowned self] response in
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                do {
                    let doc: Document = try SwiftSoup.parse(utf8Text)
                    let top12 = try doc.getElementsByClass("top12").first()
                    var top12Array = [Anime]()
                    if let topList = try? top12?.getElementsByTag("li") {
                        top12Array = self.parseIntoAnimeArray(elements: topList)
                    }
                    completionHandler(top12Array)
                } catch {
                    print("error")
                }
            }
        }
    }
    
    func getLastWeekChapters(completionHandler: @escaping ([[String:[Anime]]]) -> Void) {
        AF.request(AIDClient.baseURL).responseJSON {[unowned self] response in
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                do {
                    let doc: Document = try SwiftSoup.parse(utf8Text)
                    
                    if let lastCaps = try doc.getElementsByClass("lastcap").first(), let days = try? lastCaps.getElementsByClass("title"), let chapters = try? lastCaps.getElementsByClass("dia") {
                        var weekElements = [[String:[Anime]]]()
                        
                        for i in 0..<days.size() {
                            let rawDate = try days[i].text()
                            let dayDate = rawDate.contains(":") ? String(rawDate.split(separator: ":").last!) : rawDate
                            
                            let dayContent = try chapters[i].getElementsByTag("article")
                            weekElements.append([dayDate : self.parseIntoAnimeArray(elements: dayContent)])
                        }
                        completionHandler(weekElements)
                    }
                } catch {
                    print("error")
                }
            }
        }
    }
    
    func parseIntoAnimeArray(elements: Elements) -> [Anime] {
        var animeElements = [Anime]()
        for aElement: Element in elements {
            animeElements.append(self.parseWeekAnime(element: aElement))
        }
        return animeElements
    }
    
    func stripMainPath(chapterPath:String) -> String {
        return String(chapterPath.replacingOccurrences(of: "-\(String(chapterPath.split(separator: "-").last!))", with: "").replacingOccurrences(of: "/v/", with: "/"))
    }
}

class AnimeCard {
    let nameRomani: String!
    let nameKanji: String!
    let cover: String!
    let status: Elements!
    let sinopsis: String!
    let tags: Elements!
    let chapters: Chapters!
    
    init(nameRomani: String, nameKanji:String, cover:String, status:Elements, sinopsis: String, tags: Elements, latest: Chapters) {
        self.nameRomani = nameRomani
        self.nameKanji = nameKanji
        self.cover = cover
        self.status = status
        self.sinopsis = sinopsis
        self.tags = tags
        self.chapters = latest
    }
}

extension AnimeCard: CustomStringConvertible {
    var description: String {
        var description = ""
        description += "name: \(self.nameRomani!)\n"
        description += "kanji: \(self.nameKanji!)\n"
        description += "cover: \(self.cover!)\n"
        description += "sinopsis: \(self.sinopsis!)\n"
        description += "chapters: \(self.chapters!)\n"
        return description
    }
}

struct Chapters: CustomStringConvertible {
    let lastChapter: Int!
    let publishDate: String!
    let hRef: String!
    
    var description: String {
        var description = ""
        description += "lastChapter: \(String(describing: lastChapter!))\n"
        description += "publishedDate: \(String(describing: publishDate!))\n"
        description += "Path: \(String(describing: hRef!))"
        return description
    }
}

struct Anime: CustomStringConvertible {
    let animeName: String!
    let lastChapter: String!
    let publishDate: String!
    let pathToMain: String!
    let pathToLatest: String!
    let cover: String!
    
    var description: String {
        var description = ""
        description += "animeName: \(String(describing: animeName!))\n"
        description += "lastChapter: \(String(describing: lastChapter!))\n"
        description += "publishedDate: \(String(describing: publishDate!))\n"
        description += "path: \(String(describing: pathToMain!))"
        description += "latest: \(String(describing: pathToLatest!))"
        description += "Cover: \(String(describing: cover!))"
        return description
    }
}
