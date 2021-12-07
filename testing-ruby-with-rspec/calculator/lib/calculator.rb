class Calculator
  def add(*args)
    args.sum
  end
    
  def multiply(*args)
    args.reduce(1, :*)  
  end

  def subtract(a, b)
    a - b
  end

  def divide(a, b)
    b == 0 ? "ERROR" : a / b 
  end
end