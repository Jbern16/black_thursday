class BasicOperations

  def self.average_by_quantity(repo_1, repo_2)
   (repo_1.all.length.to_f / repo_2.all.length.to_f).round(2)
  end

end
