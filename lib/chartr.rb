class Chartr

  COLORS = ['FF0000', '00FF00', '0000FF', '000000', 'EAD5FC', 'FECF3D', '8F8F94', 'FFFF00', '00FFFF', '3F3F3F', 'D0D0D0']
  
  def self.simple_encode(values, max_value = nil)
    simple_values = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    max_value = values.max unless max_value
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
  
  
  def self.make_multiple_line_chart(value_sets, labels, legend_labels, title, size="200x100", max_y = nil)
    
    data_sets = []
    set_colors = []
    max = 0
    # find the max value, which we provide to simple encode 
    # so that all data is graphed with the same max. graphs don't
    # make sense otherwise
    max = max_y || value_sets.flatten.max
    
    value_sets.each_with_index do |value_set, index|
      data_sets << simple_encode(value_set, max)
      set_colors << COLORS[index % COLORS.length]
    end
    
    data = "&amp;chd=s:#{data_sets.join(',')}"
    colors ="&amp;chco=#{set_colors.join(',')}"
    legend = "&amp;chdl=#{legend_labels.join('|')}"
    x_axis = "&amp;chxt=x,y&amp;chxl=0:|#{labels.join('|')}|1:|0|#{max}"
    image_str =<<-START
    <img src="http://chart.apis.google.com/chart?chs=#{size}&amp;#{data}#{legend}#{colors}&amp;cht=lc&amp;" alt="#{title}" />
    START

    image_str
  end
  
  
  # make a stacked bar chart
  #
  #
  # the colors array is used if provided. the color used will cycle through the values in this array.
  def self.make_stacked_bar_chart(value_sets, labels, legend_labels, title, size="200x100", max_y = nil, colors = nil)
    
    data_sets = []
    set_colors = []
    max = 0
    # find the max value, which we provide to simple encode 
    # so that all data is graphed with the same max. graphs don't
    # make sense otherwise
    max = max_y || value_sets.flatten.max
    
    value_sets.each_with_index do |value_set, index|
      data_sets << simple_encode(value_set, max)
      if colors
        set_colors << colors[index % colors.length]   
      else
        set_colors << COLORS[index % COLORS.length]
      end
    end

    data = "&amp;chd=s:#{data_sets.join(',')}"
    colors ="&amp;chco=#{set_colors.join(',')}"
    legend = "&amp;chdl=#{legend_labels.join('|')}"
    image_str =<<-START
    <img src="http://chart.apis.google.com/chart?chs=#{size}&amp;#{data}#{legend}#{colors}&amp;cht=bvs&amp;chxt=x,y&amp;chxl=0:|#{labels.join('|')}|1:||#{max}" alt="#{title}" />
    START

    image_str
  end
  
end