#import "utils.typ"

// Load CV Data from YAML
//#let info = yaml("cv.typ.yml")

// Variables
//#let headingfont = "Linux Libertine" // Set font for headings
//#let bodyfont = "Linux Libertine"   // Set font for body
//#let fontsize = 10pt // 10pt, 11pt, 12pt
//#let linespacing = 6pt

//#let showAddress = true // true/false Show address in contact info
//#let showNumber = true  // true/false Show phone number in contact info

// set rules
#let setrules(uservars, doc) = {
    set page(
        paper: "us-letter", // a4, us-letter
        numbering: "1 / 1",
        number-align: center, // left, center, right
        margin: 1.25cm, // 1.25cm, 1.87cm, 2.5cm
    )

    // Set Text settings
    set text(
        font: uservars.bodyfont,
        size: uservars.fontsize,
        hyphenate: false,
    )

    // Set Paragraph settings
    set par(
        leading: uservars.linespacing,
        justify: true,
    )

    doc
}

// show rules
#let showrules(uservars, doc) = {
    // Uppercase Section Headings
    show heading.where(
        level: 2,
    ): it => block(width: 100%)[
        #set align(left)
        #set text(font: uservars.headingfont, size: 1em, weight: "bold")
        #upper(it.body)
        #v(-0.75em) #line(length: 100%, stroke: 1pt + black) // Draw a line
    ]

    // Name Title
    show heading.where(
        level: 1,
    ): it => block(width: 100%)[
        #set text(font: uservars.headingfont, size: 1.5em, weight: "bold")
        #upper(it.body)
        #v(2pt)
    ]

    doc
}

// Set Page Layout
#let cvinit(doc) = {
    doc = setrules(doc)
    doc = showrules(doc)

    doc
}

// Address
#let addresstext(info, uservars) = {
    if uservars.showAddress {
        block(width: 100%)[
            #info.personal.location.city, #info.personal.location.region, #info.personal.location.country #info.personal.location.postalCode
            #v(-4pt)
        ]
    } else {none}
}

// Arrange the contact profiles with a diamond separator
#let contacttext(info, uservars) = block(width: 100%)[
    // Contact Info
    // Create a list of contact profiles
    #let profiles = (
        box(link("mailto:" + info.personal.email)),
        if uservars.showNumber {box(link("tel:" + info.personal.phone))} else {none},
        box(link(info.personal.url)[#info.personal.url.split("//").at(1)]),
    )

    // Remove any none elements from the list
    #if none in profiles {
        profiles.remove(profiles.position(it => it == none))
    }

    // Add any social profiles
    #if info.personal.profiles.len() > 0 {
        for profile in info.personal.profiles {
            profiles.push(
                box(link(profile.url)[#profile.url.split("//").at(1)])
            )
        }
    }

    // #set par(justify: false)
    #set text(font: uservars.bodyfont, weight: "medium", size: uservars.fontsize * 1)
    #pad(x: 0em)[
        #profiles.join([#sym.space.en #sym.diamond.filled #sym.space.en])
    ]
]

// Create layout of the title + contact info
#let cvheading(info, uservars) = {
    align(center)[
        = #info.personal.name
        #addresstext(info, uservars)
        #contacttext(info, uservars)
        // #v(0.5em)
    ]
}

// Education
#let cveducation(info) = {
    if info.education != none {block(breakable: false)[
        == Education
        #for edu in info.education {
            // Parse ISO date strings into datetime objects
            let start = utils.strpdate(edu.startDate)
            let end = utils.strpdate(edu.endDate)
            // Create a block layout for each education entry
            block(width: 100%)[
                // Line 1: Institution and Location
                *#link(edu.url)[#edu.institution]* #h(1fr) *#edu.location* \
                // Line 2: Degree and Date Range
                #text(style: "italic")[#edu.studyType in #edu.area] #h(1fr)
                #start #sym.dash.en #end
                // - *Honors*: #edu.honors.join(", ")
                - *Courses*: #edu.courses.join(", ")
                // #for hi in edu.highlights [- #eval("[" + hi + "]")]
            ]
        }
    ]}
}

// Work Experience
#let cvwork(info) = {
    if info.work != none {block(breakable: false)[
        == Work Experience

        #for w in info.work {
            // Parse ISO date strings into datetime objects
            let start = utils.strpdate(w.startDate)
            let end = utils.strpdate(w.endDate)

            // Create a block layout for each education entry
            block(width: 100%)[
                // Line 1: Institution and Location
                *#link(w.url)[#w.organization]* #h(1fr) *#w.location* \
                // Line 2: Degree and Date Range
                #text(style: "italic")[#w.position] #h(1fr)
                #start #sym.dash.en #end \
                // Highlights or Description
                #for hi in w.highlights [
                    - #eval("[" + hi + "]")
                ]
            ]
        }
    ]}
}

// Leadership and Activities
#let cvaffiliations(info) = {
    if info.affiliations != none {block(breakable: false)[
        == Leadership & Activities

        #for org in info.affiliations {
            // Parse ISO date strings into datetime objects
            let start = utils.strpdate(org.startDate)
            let end = utils.strpdate(org.endDate)

            // Create a block layout for each education entry
            block(width: 100%)[
                // Line 1: Institution and Location
                *#link(org.url)[#org.organization]* #h(1fr) *#org.location* \
                // Line 2: Degree and Date Range
                #text(style: "italic")[#org.position] #h(1fr)
                #start #sym.dash.en #end \
                // Highlights or Description
                #if org.highlights != none {
                    for hi in org.highlights [
                        - #eval("[" + hi + "]")
                    ]
                } else {}
            ]
        }
    ]}
}

// Projects
#let cvprojects(info) = {
    if info.projects != none {block(breakable: false)[
        == Projects

        #for project in info.projects {
            // Parse ISO date strings into datetime objects
            let start = utils.strpdate(project.startDate)
            let end = utils.strpdate(project.endDate)

            // Create a block layout for each education entry
            block(width: 100%)[
                // Line 1: Institution and Location
                *#link(project.url)[#project.name]* \
                // Line 2: Degree and Date Range
                #text(style: "italic")[#project.affiliation]  #h(1fr) #start #sym.dash.en #end \
                // Summary or Description
                #for hi in project.highlights [
                    - #eval("[" + hi + "]")
                ]
            ]
        }
    ]}
}

// Honors and Awards
#let cvawards(info) = {
    if info.awards != none {block(breakable: false)[
        == Honors & Awards

        #for award in info.awards {
            // Parse ISO date strings into datetime objects
            let date = utils.strpdate(award.date)

            // Create a block layout for each education entry
            block(width: 100%)[
                // Line 1: Institution and Location
                *#link(award.url)[#award.title]* #h(1fr) *#award.location*\
                // Line 2: Degree and Date Range
                Issued by #text(style: "italic")[#award.issuer]  #h(1fr) #date \
                // Summary or Description
                #if award.highlights != none {
                    for hi in award.highlights [
                        - #eval("[" + hi + "]")
                    ]
                } else {}
            ]
        }
    ]}
}

// Certifications
#let cvcertificates(info) = {
    if info.certificates != none {block(breakable: false)[
        == Licenses & Certifications

        #for cert in info.certificates {
            // Parse ISO date strings into datetime objects
            let date = utils.strpdate(cert.date)

            // Create a block layout for each education entry
            block(width: 100%)[
                // Line 1: Institution and Location
                *#link(cert.url)[#cert.name]* \
                // Line 2: Degree and Date Range
                Issued by #text(style: "italic")[#cert.issuer]  #h(1fr) #date \
            ]
        }
    ]}
}

// Research & Publications
#let cvpublications(info) = {
    if info.publications != none {block(breakable: false)[
        == Research & Publications

        #for pub in info.publications {
            // Parse ISO date strings into datetime objects
            let date = utils.strpdate(pub.releaseDate)

            // Create a block layout for each education entry
            block(width: 100%)[
                // Line 1: Institution and Location
                *#link(pub.url)[#pub.name]* \
                // Line 2: Degree and Date Range
                Published on #text(style: "italic")[#pub.publisher]  #h(1fr) #date \
            ]
        }
    ]}
}

// Skills, Languages, and Interests
#let cvskills(info) = {
    if (info.languages != none) or (info.skills != none) or (info.interests != none) {block(breakable: false)[
        == Skills, Languages, Interests

        #if (info.languages != none) [
            #let langs = ()
            #for lang in info.languages {
                langs.push([#lang.language (#lang.fluency)])
            }
            - *Languages*: #langs.join(", ")
        ]
        #if (info.skills != none) [
            #for group in info.skills [
                - *#group.category*: #group.skills.join(", ")
            ]
        ]
        #if (info.interests != none) [
            - *Interests*: #info.interests.join(", ")
        ]
    ]}
}

// References
#let cvreferences(info) = {
    if info.references != none {block(breakable: false)[
        == References

        #for ref in info.references [
            - *#link(ref.url)[#ref.name]*: "#ref.reference"
        ]
    ]} else {}
}

// #cvreferences

// =====================================================================

// End Note
#let endnote = {
    place(
        bottom + right,
        block[
            #set text(size: 5pt, font: "Consolas", fill: silver)
            \*This document was last updated on #datetime.today().display("[year]-[month]-[day]") using #strike[LaTeX] #link("https://typst.app")[Typst].
        ]
    )
}

// #place(
//     bottom + right,
//     dy: -71%,
//     dx: 4%,
//     rotate(
//         270deg,
//         origin: right + horizon,
//         block(width: 100%)[
//             #set align(left)
//             #set par(leading: 0.5em)
//             #set text(size: 6pt)

//             #super(sym.dagger) This document was last updated on #raw(datetime.today().display("[year]-[month]-[day]")) using #strike[LaTeX] #link("https://typst.app")[Typst].
//             // Template by Je Sian Keith Herman.
//         ]
//     )
// )
