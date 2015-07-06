Pod::Spec.new do |s|
  s.name             = "DZLoadMore"
  s.version          = "0.1.1"
  s.summary          = "Load More and Pull-to-Refresh functionality for your UITableViewController"
  s.description      = <<-DESC
    This class helps to add "Load more" and "Pull-to-refresh" functionality to your table-based controller. It is block based data source class that should be subclassed and used as UITableView's dataSource"
                       DESC
  s.homepage         = "https://github.com/zigdanis/DZLoadMore"
  s.screenshots      = "http://i.imgur.com/zQEjGhFl.png", "http://i.imgur.com/nbWyMH2l.png"
  s.license          = 'MIT'
  s.author           = { "Danis Ziganshin" => "zigdanis@gmail.com" }
  s.source           = { :git => "https://github.com/zigdanis/DZLoadMore.git", :tag => s.version.to_s }
  s.platform         = :ios, '7.0'
  s.requires_arc     = true
  s.source_files     = 'DZLoadMoreDemo/DZLoadMore'
end
