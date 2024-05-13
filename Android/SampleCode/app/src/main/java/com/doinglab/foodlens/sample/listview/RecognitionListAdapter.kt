package com.doinglab.foodlens.sample.listview

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.ListAdapter
import androidx.recyclerview.widget.RecyclerView
import com.doinglab.foodlens.sample.R

class RecognitionListAdapter :
    ListAdapter<RecognitionItem, RecognitionListAdapter.ViewHolder>(DiffCallback()) {

    inner class ViewHolder(layout: View) : RecyclerView.ViewHolder(layout) {
        private var ivFoodIcon = layout.findViewById<ImageView>(R.id.img_food)
        private var tvFoodName = layout.findViewById<TextView>(R.id.tv_foodname)
        private var tvFoodPosition = layout.findViewById<TextView>(R.id.tv_food_position)
        private var tvFoodNutritionInfo = layout.findViewById<TextView>(R.id.tv_food_nutrition_info)
        private var tvEnergy = layout.findViewById<TextView>(R.id.tv_energy)


        fun bind(item: RecognitionItem) {
            item.icon?.let {
                ivFoodIcon.setImageDrawable(item.icon)
            }
            tvFoodName.text = item.name
            tvFoodPosition.text = item.foodPosition
            tvFoodNutritionInfo.text = item.foodNutrition
            tvEnergy.text = item.energy
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.list_recognition_item, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val item = getItem(position)
        holder.bind(item)
    }

    class DiffCallback : DiffUtil.ItemCallback<RecognitionItem>() {
        override fun areItemsTheSame(oldItem: RecognitionItem, newItem: RecognitionItem): Boolean {
            return oldItem.hashCode() == newItem.hashCode()
        }

        override fun areContentsTheSame(oldItem: RecognitionItem, newItem: RecognitionItem): Boolean {
            return oldItem == newItem
        }
    }

}