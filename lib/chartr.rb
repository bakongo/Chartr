class Chartr

  COLORS = ['FF0000', '00FF00', '0000FF', '000000', 'EAD5FC', 'FECF3D', '8F8F94', 'FFFF00', '00FFFF', '3F3F3F', 'D0D0D0']
  
  def self.simple_encode(values, max_value = nil)
    simple_values = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    max_value = values.max unless max_value
    max_value = 1 if max_value == 0
    chart_data = [""]
    values.each do |v|
      val = Float(v)
      if (!val.nan? && v >= 0)   
        chart_data.push(simple_values[( (simple_values.length-1) * val / max_value).round, 1]);
      else
        chart_data.push('_');
      end
    end
    return chart_data.join('');
  end

  def self.make_simple_line_chart(values, labels, title, size="200x100", max_y = nil)
    
    max = max_y || values.max
    image_str =<<-START
    <img src="http://chart.apis.google.com/chart?chs=#{size}&amp;chd=s:#{simple_encode(values, max)}&amp;cht=lc&amp;chxt=x,y&amp;chxl=0:|#{labels.join('|')}|1:||#{max}" alt="#{title}" />
    START

    image_str
  end
  
  
  # value sets: an array of arrays of values to be graphed
  #
  #
  def self.make_multiple_line_chart(value_sets, labels, legend_labels, title, size="200x100", max_y = nil, colors = nil)

    chart_args = Chartr.process_multi_data_set(value_sets, labels, legend_labels, size, max_y, colors)
    chart_type = "cht=lc"
    chart_args << chart_type
    
    google_chart_string = chart_args.join("&amp;")
        
    image_str =<<-START
    <img src="http://chart.apis.google.com/chart?#{google_chart_string}" alt="#{title}" />
    START

    image_str
  end
  
  
  # make a stacked bar chart. need to provide multiple sets of data to graph
  #
  #
  # the colors array is used if provided. the color used will cycle through the values in this array.
  def self.make_stacked_bar_chart(value_sets, labels, legend_labels, title, size="200x100", max_y = nil, colors = nil)
    
    chart_args = Chartr.process_multi_data_set(value_sets, labels, legend_labels, size, max_y, colors)
    chart_type = "cht=bvs"
    chart_args << chart_type
    google_chart_string = chart_args.join("&amp;")

    
    image_str =<<-START
    <img src="http://chart.apis.google.com/chart?#{google_chart_string}" alt="#{title}" />
    START

    image_str
  end
  
  protected 
  
  def self.process_multi_data_set(value_sets, labels, legend_labels, size, max_y, colors)
    data_sets = []
    set_colors = []
    max = 0
    
    # find the max value, which we provide to simple encode 
    # so that all data is graphed with the same max. graphs don't
    # make sense otherwise
    max = max_y || value_sets.flatten.max
    
    value_sets.each_with_index do |value_set, index|
      data_sets << simple_encode(value_set, max)
      set_colors << Chartr.get_color(index, colors)
    end

    data = "chd=s:#{data_sets.join(',')}"
    colors ="chco=#{set_colors.join(',')}"
    legend = "chdl=#{legend_labels.join('|')}" unless legend_labels.length == 0
    legends = "chxt=x,y"
    x_axis = "chxl=0:|#{labels.join('|')}|1:||#{max}"
    size = "chs=#{size}"
    
    [size, data, legend, legends, x_axis, colors]
  end
  
  
  def self.get_color(index, colors)
    if colors
      colors[index % colors.length]   
    else
      COLORS[index % COLORS.length]
    end
  end
  
end