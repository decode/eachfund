class CreateHouses < ActiveRecord::Migration
  def change
    create_table :houses do |t|
      # 房屋编号
      t.string :identifier
      # 房屋名称
      t.string :name
      # 所在地区
      t.string :region
      t.string :province
      t.string :city
      t.string :district
      # 详细地址
      t.string :address
      # 房屋类型
      t.string :house_type
      # 出租类型
      t.string :rent_type
      # 房屋面积
      t.decimal :area
      # 房间套数
      t.integer :house_count
      # 楼层
      t.integer :floor
      # 楼层类型
      t.string :floor_type
      # 容量
      t.string :capacity
      # 床位
      t.string :bed
      # 朝向
      t.string :direction
      # 配套设施
      t.text :facility
      # 环境
      t.text :environment
      # 服务
      t.text :service
      # 周边
      t.text :surrounding
      # 入住时间
      t.string :checkin
      # 退房时间
      t.string :checkout
      # 营业时间
      t.string :open
      t.string :close
      # 最多天数
      t.integer :max_day
      # 最少天数
      t.integer :min_day
      # 其它
      t.text :other
      # 房屋套数
      t.integer :amount

      # 房屋状态
      # 保存为: 草稿 发布 未发布 无效 删除
      t.string :status

      t.references :user, index: true

      t.timestamps
    end
  end
end
