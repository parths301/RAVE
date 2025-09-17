//
//  AppleHIGuidelines.md
//  RAVE
//
//  Created by Parth Sharma on 17/09/25.
//

Convert every aspect of my app’s UI, UX, visual layout, and language to strictly follow the Apple design style as codified in the Apple Style Guide (June 2025). The final result must be indistinguishable from a native Apple application in terms of aesthetics, interaction, structure, and language. Pay extreme attention to all positioning, sizing, order, spacing, color, and terminology conventions. Use the following detailed requirements:

1. UI Structure & Layout
Margins & Padding: Use generous padding around UI sections (minimum ~16pt standard; for modals/dialogs, up to 20pt). Maintain at least 8pt spacing between grouped elements (e.g., form fields, buttons within a group).

Grid Layout: Use an 8pt baseline grid for all horizontal and vertical spacing.

Alignment: All elements align to the grid and to one another. Major titles and sections are left-aligned unless design requires center alignment.

Window Controls (macOS): Place close (red), minimize (yellow), and zoom (green) buttons at the top left of windows, spaced evenly and sized at 12x12pt.

Forms: Text fields are a minimum of 28pt high, with 16pt padding. Labels are above fields, left-aligned.

2. Controls & Interactive Elements
Buttons: Height: 44pt standard for touch; 32pt for macOS click targets. Horizontal padding: 16pt minimum. Corner radius: 8pt (standard roundness for Apple controls). All buttons must have clear affordances (shadows, color, or border).

Checkboxes & Radio Buttons: Dimensions: 18pt; labels flush left of the element, minimum 8pt gutter.

Toggles/Switches: Use the Apple style toggle, with 44pt minimum height for touch devices. Always use “on/off”, not “enabled/disabled.”

Tab Bars: Height: 49pt on iOS, with icon size 24pt and text 10pt, both centered.

Navigation Bars: iOS navigation bars are 44pt high; macOS title bars are taller (typically 50-60pt).

Toolbars: Minimum 30pt high, use icon-only or icon+label standards, icons 20-24pt.

Dialogs: Rounded corners, 16pt minimum padding. Buttons right-justified, primary action in blue.

4. Typography
Font: Use San Francisco (SF Pro for macOS, SF Pro Rounded, SF Compact for iOS), fallback Helvetica Neue or Arial if unavailable.

Font Weights: Titles: semibold or bold; body text: regular.

Sizes: Large titles (34pt), section headers (21pt), body (17pt), secondary (15pt), captions (13pt).

Line Height: Minimum 1.2x font size (17pt body → 20pt line height).

Letter Spacing: Use Apple’s tight tracking (-0.4 to 0).

Use dynamic type for accessibility—support text scaling for all user-facing text.

5. Color & Icons
Color Palette: Use Apple’s system color palette (on iOS: systemBackground, label, secondaryLabel, systemBlue for accent/actions).

Elements that require attention use systemRed (warnings, destructive actions).

Buttons: systemBlue for primary, secondaryLabel for neutral, systemGray for background.

Icons: Use SF Symbols for standard icons and ensure they scale with text. Maintain icon size and weight consistency.

Badges: Red oval or circle, minimum 18x18pt, numerals centered in bold san serif font.

6. Component Placement & Behavior
Navigation: Place primary navigation at the top (macOS) or in tab bars/bottom bars (iOS). Never put key navigation actions in floating buttons unless overridden by HIG exceptions.

Lists: List cells: minimum height 44pt (iOS), 32pt (macOS). Chevron icons 16pt wide, right-side, vertically centered.

Section Dividers: Use 1pt hairline separators with appropriate system color (systemGray4).

Modals/Sheets: Rounded corners 20pt radius, edge-to-edge on iPhone (with 16-20pt margins), floating on iPad/Mac.

7. Accessibility
Contrast: Text and interactive elements must meet WCAG 2.1 AA minimum contrast ratio (4.5:1 normal, 3:1 large text).

All clickable/tappable items minimum 44x44pt hit area.

Support VoiceOver by ensuring semantic structure in the code for all elements and appropriate ARIA roles or accessibility labels.

8. Microinteractions & Feedback
Progress Indicators: Circular spinning indicator for asynchronous, linear bar for determinate.

Touch Feedback: All interactive elements must have visible pressed/active/hovered states.

Animation: Subtle, fluid, non-distracting. Duration for standard UI transitions: 0.3s.

9. Document & Code
File Naming: Lowercase, hyphen-separated, consistent with element/component names.

Code Styles: Camel-case for variables, PascalCase for class names, snake_case for file and folder names (unless Apple’s frameworks dictate otherwise).

Result Expectation:
Every part of the finished UI/UX, from the names and labels to element sizes, text, margins, color usage, interaction, and accessibility, should conform 100% to these specifications. If context is ever ambiguous, follow the system defaults as per the Apple Human Interface Guidelines and Style Guide for the relevant platform.

                        ## Apple Design Philosophy: A Comprehensive Summary (June 2025)

                        This document provides a detailed summary of the Apple Style Guide dated June 2025, intended to serve as a comprehensive design philosophy for creating materials that align with Apple's standards. It covers typography, color, layout, UI elements, and accessibility, drawing directly from the provided guide. For broader UI and interaction design principles not covered in this specific style guide, designers and developers should refer to Apple's official Human Interface Guidelines.

                        ### Core Principles

                        The cornerstone of Apple's design philosophy is the creation of a consistent and intuitive user experience. This is achieved through a clear and consistent voice across all materials, from technical documentation to user interfaces. The guide emphasizes high-quality, readable, and consistent materials that feel native to the Apple ecosystem.

                        ### Typography

                        The Apple Style Guide provides specific rules for the treatment of text to ensure clarity and consistency.

                        #### **Font Usage**

                        *   **Code Font:** A fixed-width font, such as Courier, is to be used for code listings, text the user needs to type, computer-language elements, and commands in running text.
                        *   **Body Font:** Regular body font is used for all other text, including punctuation following code font elements.

                        #### **Capitalization**

                        *   **Title-Style Capitalization:** Capitalize the first and last word, and all major words in between. This is the standard for command names and most UI elements.
                        *   **Sentence-Style Capitalization:** Capitalize only the first word and any proper nouns. This is used for figure titles and callouts.
                        *   **Product Names:** Product names starting with a lowercase letter (e.g., iPhone) should retain that capitalization even at the beginning of a sentence.

                        ### Color

                        While the provided style guide does not specify a color palette, it does give guidance on the use of color in text and UI elements.

                        *   **Color for Information:** Use color to convey information, such as `dimmed` (not hollow or grayed) to indicate an inactive or unavailable UI element.
                        *   **Avoiding Ambiguity:** The guide advises against using color as the sole means of conveying information to ensure accessibility.
                        *   **Inclusive Language:** Do not use color-based metaphors that carry positive or negative connotations (e.g., blacklist, white hat).

                        ### Sizing and Positioning

                        The guide provides specific terminology and formatting for sizes and dimensions.

                        *   **Dimensions:** Use "by" to express dimensions (e.g., 8.5 by 11 inches). The "x" character is acceptable if used consistently.
                        *   **Resolution:** Use a lowercase "x" to express screen resolution (e.g., 640 x 480).
                        *   **Pop-ups and Popovers:** The guide distinguishes between a `pop-up menu` (a menu in a dialog or window) and a `popover` (a transient view that appears above other content). The term "pop-up" is also used for ads and unsolicited browser notices.
                        *   **Dialogs and Sheets:** In user materials, use the term `dialog`. In developer materials, `panel` or `sheet` may be more appropriate depending on the context. A `sheet` is a dialog attached to a specific window.

                        ### Design Elements and UI Components

                        The guide provides a detailed glossary of approved terminology and usage for various UI elements.

                        #### **Buttons**

                        *   **General:** Buttons initiate an action when clicked, tapped, or pressed.
                        *   **Text Labels:** Button names should be written exactly as they appear on screen. Use title-style capitalization for buttons with all caps or title-case labels.
                        *   **Icons:** An element that acts like a button should be called a `button`, even if it's just an icon.
                        *   **Specific Buttons:** The guide defines the `More button` (with an ellipsis), `Back button`, `Forward button`, `close button`, `minimize button`, and `maximize button`.

                        #### **Menus**

                        *   **Pull-down menus:** Menus in the menu bar.
                        *   **Pop-up menus:** Menus in a dialog or window.
                        *   **Shortcut menus:** Contextual menus that appear on Control-click.
                        *   **Submenus:** Hierarchical menus indicated by a right arrow.

                        #### **Windows and Views**

                        *   **Window:** The general term for an app's main interface area on macOS and visionOS.
                        *   **Split View:** The feature for viewing two apps side by side.
                        *   **App Store:** Note the capitalization and use of "in," "on," or "from" the App Store.
                        *   **Today View:** Do not precede with "the."

                        #### **Clarity and Wording**

                        *   **Clarity:** Prioritize clear and direct language. For example, instead of "the user must," phrase instructions from the user's perspective ("you can").
                        *   **Conciseness:** Avoid unnecessary words. For example, use "to" instead of "in order to."
                        *   **Active Voice:** Use the active voice whenever possible.
                        *   **Positive Framing:** Frame instructions and descriptions in a positive and empowering way.
                        *   **Avoid Jargon:** Define technical terms on first use.

                        ### Accessibility

                        Apple places a strong emphasis on creating products that are accessible to everyone. The "Writing Inclusively" section of the style guide provides detailed guidance.

                        *   **Person-First vs. Identity-First Language:** The guide explains the distinction and advises asking for an individual's preference when possible.
                        *   **Gender-Neutral Language:** Use "they," "their," and "them" as singular, gender-neutral pronouns. Avoid binary representations of gender.
                        *   **Disability:** Focus on the person's accomplishments and story, not their disability. Acknowledge the wide range of disabilities and avoid ableist language.
                        *   **Avoid Sensory Language:** In instructions, describe what happens rather than what the user sees or hears (e.g., "a message appears" instead of "you see a message").
                        *   **Inclusive Terminology:** The guide provides a table of preferred terms to use when writing about disability.

                        ### Positioning of Elements

                        The guide provides specific instructions for describing the location of elements on the screen.

                        *   **Above/Below:** Use `above` or `below` to describe text or an object that closely precedes or follows the current paragraph.
                        *   **In Front:** Use `in front` to describe the active window.
                        *   **Onscreen:** Use `onscreen` as a single word (adjective or adverb).
                        *   **Cross-References:** For elements not immediately adjacent, use cross-references.

                        ### Boxes and Pop-ups

                        *   **Dialog:** The preferred term for a window that requests information from the user. Do not use `dialog box`.
                        *   **Alert:** A type of dialog that provides a warning or error message.
                        *   **Popover:** A view that appears over other content and is dismissed by tapping outside of it.
                        *   **Action Sheet:** An alert that presents choices related to the current context.

                        This summary is intended to be a living document, to be updated as Apple's design philosophy evolves. For the most current and comprehensive information, always refer to the latest official Apple Style Guide and Human Interface Guidelines.
