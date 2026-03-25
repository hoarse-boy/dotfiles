from kitty.fast_data_types import Screen, get_options
from kitty.tab_bar import (
    DrawData, TabBarData, ExtraData, as_rgb
)
from kitty.utils import color_as_int

opts = get_options()

# Matugen theme colors
BG = as_rgb(0x0e1415)           # surface/background
FG = as_rgb(0xdee4e4)           # on_surface
ERROR = as_rgb(0xffb4ab)        # error - red for highlight
OUTLINE = as_rgb(0x899393)      # outline - for inactive

border_left = ""
border_right = ""
separator = ""

# Minimum characters for tab titles
MIN_TITLE_LENGTH = 8


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    # Initialize storage on first call
    if not hasattr(extra_data, 'tab_widths'):
        extra_data.tab_widths = []
        extra_data.total_width = 0
    
    # Process title
    title = tab.title
    
    # Remove # prefix if present
    if title.startswith("#"):
        title = title[1:]
    
    # Check if this is an unnamed tab (starts with ~ or contains typical path patterns)
    # Unnamed tabs: "~", "~/something", "/home/user", etc.
    # Named tabs: "nvim", "python", "my-project", etc.
    is_unnamed = title.startswith("~") or ("/" in title and not title.startswith("#"))
    
    # For unnamed tabs, show empty name (just ID)
    # For named tabs, show the name
    if is_unnamed:
        display_title = ""  # No name for unnamed tabs
    else:
        # Apply minimum length for named tabs
        effective_max = max(max_title_length, MIN_TITLE_LENGTH)
        display_title = title[:effective_max] if len(title) > effective_max else title
    
    # Calculate width (adjust for empty title)
    tab_id = str(tab.tab_id)
    if display_title:
        text = f"{tab_id}{separator} {display_title}"
    else:
        text = f"{tab_id}"  # Just ID for unnamed tabs
    
    width = len(border_left) + len(text) + len(border_right)
    
    # Store for later
    extra_data.tab_widths.append((tab, display_title, width, is_unnamed))
    extra_data.total_width += width + (0 if is_last else 1)
    
    if is_last:
        # Calculate center position
        center_offset = (screen.columns - extra_data.total_width) // 2
        if center_offset < 0:
            center_offset = 0
        
        # Move to center
        screen.cursor.x = center_offset
        
        # Draw ALL tabs here
        for i, (t, disp_title, w, unnamed) in enumerate(extra_data.tab_widths):
            color = ERROR if t.is_active else OUTLINE
            
            # Reset font attributes (fixes italic bug)
            screen.cursor.bold = False
            screen.cursor.italic = False
            screen.cursor.strikethrough = False
            
            # Draw left border
            screen.cursor.bg = 0
            screen.cursor.fg = color
            screen.draw(border_left)
            
            # Draw ID (bold)
            screen.cursor.bg = color
            screen.cursor.fg = BG
            screen.cursor.bold = True
            screen.draw(str(t.tab_id))
            screen.cursor.bold = False
            
            # Draw separator and title only if named
            if not unnamed and disp_title:
                # Draw separator
                screen.cursor.fg = color
                screen.cursor.bg = BG
                screen.draw(separator)
                
                # Draw title
                screen.cursor.fg = FG
                screen.draw(f" {disp_title}")
            
            # Draw right border
            screen.cursor.fg = BG
            screen.cursor.bg = 0
            screen.draw(border_right)
            
            # Space between tabs
            if i < len(extra_data.tab_widths) - 1:
                screen.draw(" ")
        
        # Clear storage
        extra_data.tab_widths = []
        extra_data.total_width = 0
        
        return screen.cursor.x
    
    # IMPORTANT: Non-last tabs return BEFORE position (no drawing)
    return before
