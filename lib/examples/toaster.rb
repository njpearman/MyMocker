module Examples
  # This is a toaster.  A toaster toasts things (but never with champagne)
  class Toaster
    def add food
      @food = food
      return self
    end

    def press_switch
      @food.toast
    end
  end
end
