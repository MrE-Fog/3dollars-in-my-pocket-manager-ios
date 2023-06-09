struct Land: Decodable {
    let number1: String
    let number2: String
    let name: String?
    let addition0: Addition?
    
    enum CodingKeys: String, CodingKey {
        case number1
        case number2
        case name
        case addition0
    }
    
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.number1 = try values.decodeIfPresent(String.self, forKey: .number1) ?? ""
        self.number2 = try values.decodeIfPresent(String.self, forKey: .number2) ?? ""
        self.name = try values.decodeIfPresent(String.self, forKey: .name)
        self.addition0 = try values.decodeIfPresent(Addition.self, forKey: .addition0)
    }
}
