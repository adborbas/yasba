import Foundation

struct SidebarViewModel {
    let sections: [SidebarSection] = [
        SidebarSection("Controls", [
            SidebarItem(blueprint: IfCommandBlueprint()),
            SidebarItem(blueprint: StopCommandBlueprint()),
        ]),
        SidebarSection("Actions", [
            SidebarItem(blueprint: AddFlagCommandBlueprint()),
            SidebarItem(blueprint: FileIntoCommandBlueprint()),
        ]),
        SidebarSection("Proton", [
            SidebarItem(blueprint: ProtonSpamCommandBlueprint()),
            SidebarItem(blueprint: ProtonMarkAsReadCommandBlueprint()),
            SidebarItem(blueprint: ProtonExpireCommandBlueprint())
        ])
    ]
}

struct SidebarSection: Identifiable {
    let id = UUID()
    let title: String
    let items: [SidebarItem]
    
    init(_ title: String, _ items: [SidebarItem]) {
        self.title = title
        self.items = items
    }
}

struct SidebarItem: Identifiable {
    let id = UUID()
    let blueprint: SieveCommandBlueprint
    
    var title: String { blueprint.title }
    var icon: String { blueprint.icon }
    var info: String { blueprint.info }
}
