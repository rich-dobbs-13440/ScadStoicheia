function ASSEMBLE_SUBCOMPONENTS() = 3;
function PRINTING() = 4;

function layout_from_mode(mode) = 
    mode == ASSEMBLE_SUBCOMPONENTS() ? "assemble" :
    mode == PRINTING() ? "printing" :
    "unknown";

function mode_is_printing(mode) = mode == PRINTING();

// Customization variables
x_legend = 0;  // [ -200 : 200]
y_legend = 0;  // [ -200 : 200]
z_legend = 0;  // [ -200 : 200]

legend_position = [x_legend, y_legend, z_legend];

legend_text_characteristics_ = "base"; // [base, font6]

legend_text_characteristics = 
    legend_text_characteristics_ == "base" ? base_legend_text_characteristics() :
    legend_text_characteristics_ == "font6" ? font6_legend_text_characteristics() :
    assert(false);

// Stop customization
module end_of_customization() {}

function base_legend_text_characteristics() = generate_legend_text_characteristics(); 
function font6_legend_text_characteristics() = generate_legend_text_characteristics(
    font_size = 6, average_char_width = 5.6, line_height = 10, padding_factor = 0.6, cube_size_factor = 1.2, dy_factor = 1., text_color = "black", background_color = "white"); 

function visualize_info(label, color_code, alpha=1, mode="as_assembled", show_part_colors=false) = 
    assert(is_string(label))
    assert(is_string(color_code))
    [label, color_code, alpha];
    

module visualize(info) {
    color_code = info[1];
    raw_alpha = info[2];
    alpha = is_num(raw_alpha) ? raw_alpha: 
            is_bool(raw_alpha) && raw_alpha ? 1 :
            0;
    mode = info[3];
    show_part_colors = info[4];
    if (show_part_colors) {
        // Just pass through, so that underlying colors can be seen
        children();
    } else if (alpha == 0) {
        // Don't create anything.  This avoids some artifacts in rendering
        // such as wrong z ordering or not enough convexity being specified.

    } else if (mode=="hidden") {
        // Don't create anything. This allows hiding all visualize parts at once 
    } else {
        color(color_code, alpha) {
            children();
        }
    }
}


module visualize_vitamins(info) {
    raw_alpha = info[2];
    alpha = is_num(raw_alpha) ? raw_alpha: 
            is_bool(raw_alpha) && raw_alpha ? 1 :
            0;
    if (alpha > 0) {
        children();
    }
}


module generate_legend_for_visualization(visualization_infos, legend_position, legend_text_characteristics) {
    // Extract the labels and colors from the visualization_infos
    labels = [for (visualization_info = visualization_infos) visualization_info[0]];
    colors = [for (visualization_info = visualization_infos) visualization_info[1]];

    // Now call generate_legend with the extracted labels and colors
    generate_legend(labels, colors, legend_position, legend_text_characteristics);
}


// Function to generate the legend text characteristics array
function generate_legend_text_characteristics(font_size = 10, average_char_width = 10, line_height = 15, padding_factor = 1, cube_size_factor = 1, dy_factor = 1.5, text_color = "black", background_color = "white") = 
    assert(font_size > 0 && average_char_width > 0 && line_height > 0 && padding_factor >= 0 && cube_size_factor >= 0 && dy_factor >= 0)
    [font_size, average_char_width, line_height, padding_factor * average_char_width, cube_size_factor * average_char_width, dy_factor * -line_height, text_color, background_color];

// Function to generate a legend for color-coded components
module generate_legend(labels, colors, legend_position, legend_text_characteristics) {
    font_size = legend_text_characteristics[0];
    average_char_width = legend_text_characteristics[1];
    line_height = legend_text_characteristics[2];
    padding = legend_text_characteristics[3];
    s = legend_text_characteristics[4];
    dy = legend_text_characteristics[5];
    text_color = legend_text_characteristics[6];
    background_color = legend_text_characteristics[7];
    max_label_length = max([for (label = labels) len(label)]);
    y_text_offset = -line_height - padding;
         
    legend_width = max_label_length * average_char_width + 2 * padding;
    legend_height = len(labels) * line_height + 2 * padding; 

    translate(legend_position) {
        for (i = [0:len(labels)-1]) {
            translate([padding, y_text_offset + i * dy, 0]) {
                color(colors[i]) {
                    cube(s);
                }
                color(text_color) 
                    translate([line_height, 0, 0])
                        text(labels[i], size = font_size);
            }
        }
        color(background_color)
        translate([0, -legend_height, -s]) {
            cube([legend_width, legend_height, 1]); // Background rectangle for better visibility
        }
    }
}





generate_legend(componentLabels, componentColors, legend_position, legend_text_characteristics);

// Define component labels and colors
componentLabels = ["Component 1", "Component 2", "Component 3"];
componentColors = ["blue", "green", "red"];



// Main model
module myModel() {
    // Component 1
    color(componentColors[0]) {
        translate([0, 0, 0])
        sphere(20);
    }

    // Component 2
    color(componentColors[1]) {
        translate([-15, -20, 0])
        sphere(15);
    }

    // Component 3
    color(componentColors[2]) {
        translate([15, -20, 0])
        sphere(10);
    }
}




myModel();
        
    

