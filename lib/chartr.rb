class Chartr

  def self.simple_encode(values)
    simple_values = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    max_value = values.max
    chart_data = ['s:'];
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


  def self.make_simple_line_chart(values, labels, title, size="200x100")
    
    image_str =<<-START
    <img src="http://chart.apis.google.com/chart?chs=#{size}&amp;chd=#{simple_encode(values)}&amp;cht=lc&amp;chxt=x,y&amp;chxl=0:|#{labels.join('|')}|1:||#{values.max}" alt="#{title}" />
    START

    image_str
  end
  
end