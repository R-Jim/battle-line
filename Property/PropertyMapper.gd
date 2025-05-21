class_name PropertyMapper


const property_map = {
    "health_recovery": {
        "health": 1,
    }
}

static func map_properties(properties: Dictionary) -> Dictionary:
    var mapped_property = properties.duplicate()
    
    for property_name in property_map:
        if not mapped_property.has(property_name):
            continue
        
        var value = mapped_property[property_name].get_current()
        if not value:
            continue
        
        mapped_property[property_name].set_current(0)
        
        for map_property_name in property_map[property_name]:
            var modifier = property_map[property_name][map_property_name]
            mapped_property[map_property_name].add_current(value * modifier)
            
    return mapped_property
